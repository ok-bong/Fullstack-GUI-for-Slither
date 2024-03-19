# this file contains utility functions and services that are used by the main application logic such as running Slither commands.

from fastapi import UploadFile, HTTPException, status
import os
import re
import subprocess
from datetime import datetime

# folder to store the uploaded files of users and to process them using Slither
UPLOADS_DIR = "uploads"
# the file path to slither wiki, basically .md file that contains recommendation and description of a given vulnerability
# this file is clone from Slither github page: https://github.com/crytic/slither/wiki/Detector-Documentation
DETECTOR_DOCUMENT_PATH = './slither.wiki/Detector-Documentation.md'


# saves the uploaded file to the 'uploads' directory.
def save_uploaded_file(contract: UploadFile):
    try: 
        # create the 'uploads' dir if not exists, exist_ok to True to specify existing dir w/o having error
        os.makedirs(UPLOADS_DIR, exist_ok=True)

        # file path within the 'uploads' directory
        file_path = os.path.join(UPLOADS_DIR, contract.filename)

        # write the contents of the uploaded file to the specified file path
        with open(file_path, "wb") as f:
            f.write(contract.file.read())

        # return the file path where the file is saved
        return file_path
    except Exception as e:
        #  HTTPException with a 500 status code
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Error occurred while saving the file. Please try again.")


# extracts the Solidity version from the provided file path.
def extract_solidity_version(file_path: str):
    try:
        with open(file_path, "r") as f:
            # read the first 500 characters of the uploaded file
            file_content = f.read(500)

        # regexp match "pragma solidity x.y.z;" or "pragma solidity ^x.y.z;" 
        version_pattern = re.search(r"pragma solidity \^?(?P<version>\d+\.\d+\.\d+);", file_content)

        # raise an exception if no version is found
        if not version_pattern:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Solidity version not found in the file. Please upload file with a valid Solidity version for auditing.",
            )

        # return the version if found
        return version_pattern.group('version')
    except HTTPException as e: # raise HTTPException with specific error details
        raise e
    except Exception as e: # more generic errors handling
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Error occurred while extracting the Solidity version. Please try again.")

# analyses a contract by running Slither commands with the specified Solidity version.
def analyze_contract(file_path: str, solidity_version: str):
    try:
        # 3 commands needed to run Slither with the specified Solidity version using subprocess
        install_cmd = ['solc-select', 'install', solidity_version]
        use_cmd = ['solc-select', 'use', solidity_version]
        slither_cmd = ['slither', file_path, '--checklist']
        
        # run each command, check=True to check for errors
        subprocess.run(install_cmd, check=True)
        subprocess.run(use_cmd, check=True)
        
        # run slither command and redirect the output to the .md file
        # this is equivalent to "> result.md"   
        with open(f"{file_path}.md", "w") as output_file:
            subprocess.run(slither_cmd, stdout=output_file)
        
        # return the path to the generated Markdown file
        return f"{file_path}.md"
    except subprocess.CalledProcessError as e: # specific subprocess errors handling
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error running Slither. Please try again.")
    except Exception as e: # more generic errors handling
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Error analysing contract. Please try again.")

#  filter report file and extract vulnerability information from it
def filter_report(file_path: str):
    try:
        # open the .md file
        with open(file_path, "r") as f:
            md_content = f.read() # read the file

            # patterns to match vulnerability types, impact, confidence, and results. 
            vulnerability_pattern = re.compile(
                r"##\s*(?P<vulnerability_type>[\w-]+)\nImpact:\s*(?P<impact>\w+)\nConfidence:\s*(?P<confidence>\w+)(?P<results>[\s\S]+?)(?=\n##|$)"
            )

            # one vuln can have many results with different locations within the contract
            result_pattern = re.compile(r'- \[ \] ID-(?P<id>\d+)\n(?P<description>.*?)(?=\nuploads/(?P<location>\S+)|$)', re.DOTALL)

            # find matches for each vulnerability from the pattern in the md file content
            matches = re.finditer(vulnerability_pattern, md_content)

            vulnerabilities = [] # initialise the list of vulnerabilities to be returned

            # for each match in the matches list
            for match in matches:
                # convert the match to a dictionary with key value pair
                result_dict = match.groupdict()
                # prepare the vulnerability format to be returned
                vulnerability_info = {
                    "vulnerability_type": result_dict["vulnerability_type"],
                    "impact": result_dict["impact"],
                    "confidence": result_dict["confidence"],
                    "description": None,  # initialise description
                    "recommendation": None,  # initialise recommendation
                    "results": [] # initialise results list
                }

                # find matches for each result within the vulnerability
                results_matches = re.finditer(result_pattern, result_dict["results"])
                for result_match in results_matches:
                    # convert the result match to a dictionary with key value pairs
                    result = result_match.groupdict()
                    # append the result to the list of results
                    vulnerability_info["results"].append({
                        # strip the description to remove surrounding whitespace
                        "description": result["description"].strip(), 
                        "location": result["location"]
                    })

                # find description for the vulnerability type
                vulnerability_info["description"] = find_description(vulnerability_info["vulnerability_type"])

                # find recommendation for the vulnerability type
                vulnerability_info["recommendation"] = find_recommendation(vulnerability_info["vulnerability_type"])

                # append the vulnerability info to the list
                vulnerabilities.append(vulnerability_info)

            # return the list of vulnerabilities
            return vulnerabilities
    except Exception as e:
        # HTTPException with a 500 status code and the error details
        print(e)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Error occurred while filtering the report. Please try again.")


# Find the recommendation for a given check name (i.e., vulnerability).
def find_recommendation(check_name: str):
    try:
        file_path = DETECTOR_DOCUMENT_PATH # the path to the detector document
        
        # open the wiki i.e., detector documentation file
        with open(file_path, 'r') as f:
            file_content = f.read() # read the file

        # regexp pattern with named group for extracting recommendation based on each check name
        # DOTALL to also match \n character
        pattern = re.compile(
            fr'##\s.*?###\sConfiguration\n\* Check: `{check_name}`.*?###\sRecommendation\n(?P<recommendation>.*?)(?=\n##\s|\Z)',
            re.DOTALL
        )

        # search for the pattern in the content
        match = re.search(pattern, file_content)

        # return the recommendation if has a match
        if match:
            # get the named group recommendation match from the regexp
            recommendation = match.group('recommendation').strip()
            return recommendation
        
        # return this message if no recommendation was found
        return f'Recommendation not found for: {check_name}'
    except Exception as e: # error handling
        # HTTPException with a 500 status code and the error details
        print (e)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Error fetching recommendation. Please try again.")

# Find description for a given check (i.e., vulnerability) name.
def find_description(check_name: str):
    try:
        file_path = DETECTOR_DOCUMENT_PATH # the path to the detector document
        
        # open the wiki file
        with open(file_path, 'r') as f:
            file_content = f.read() # read the file
            
        # regexp pattern with named group for extracting description based on each check name
        pattern = re.compile(
            fr'##\s.*?###\sConfiguration\n\* Check: `{check_name}`.*?###\sDescription\n(?P<description>.*?)(?=\n###\sExploit Scenario:|\n##|$)',
            re.DOTALL
        )
        
        # Search for the pattern in the content
        match = re.search(pattern, file_content) 
        
        # return the description if a match is found
        if match:
            # get the description named group from the regexp
            description = match.group('description').strip()
            return description

        # return this message if no description was found
        return f'Description not found for check: {check_name}'
    except Exception as e:
        # HTTPException with a 500 status code and the error details
        print (e)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Error fetching description. Please try again.")

# get the current date in the format DD-MM-YYYY.
def get_current_date():
    return datetime.now().strftime("%d-%m-%Y")

# get the current time in the format HH:MM AM/PM.
def get_current_time():
    return datetime.now().strftime("%I:%M %p")

