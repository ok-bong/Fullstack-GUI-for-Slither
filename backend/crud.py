# this file contains functions that handle the CRUD operations (Create, Read, Update, Delete) for interacting with the database. 

from sqlalchemy.orm import Session, joinedload
from models import Report, Vulnerability, Result
from fastapi import HTTPException
from datetime import datetime

# define decorator that provides consistent error handling and cleanup for database operations.
def db_handler(func):
    # wrapper function to handle exceptions
    def wrapper(db: Session, *args, **kwargs):
        try:
            return func(db, *args, **kwargs)
        except HTTPException as e: # raise specific HTTPException if exists
            raise e
        except Exception as e: # other generic errors
            db.rollback() # rollback the changes in the db if something wrong happened
            raise HTTPException(status_code=500, detail=f"Internal Server Error. Please try again.") 
        finally:
            # ensure that the database is closed no matter what
            db.close()
    return wrapper

# upload the report to the database, this including adding data into all 3 tables: report, vulnerability, and report_vulnerability
@db_handler # use the decorator  defined above for error handling
def upload_report(db: Session, report_data: dict):
    # remove the vuln list to insert only report-related data to the db
    vulnerabilities_data = report_data.pop('vulnerabilities_details', [])
    # convert submission_date and submission_time to datetime object to insert into the db
    submission_date = datetime.strptime(report_data['submission_date'], "%d-%m-%Y").date()
    submission_time = datetime.strptime(report_data['submission_time'], "%I:%M %p").time()
    
    # reassign submission_date and submission_time to the report
    report_data['submission_date'] = submission_date 
    report_data['submission_time'] = submission_time
    
    # calculate the number of vulnerabilities
    number_of_vulnerabilities = len(vulnerabilities_data)
    # reassign number_of_vulnerabilities to the report
    report_data['number_of_vulnerabilities'] = number_of_vulnerabilities

    report = create_report(db, report_data) # save the report to the database

    # iterate through each vulnerability
    for vuln_data in vulnerabilities_data:
        # get the vulnerability type from each vuln in the list
        vulnerability_type = vuln_data.get('vulnerability_type')
        # query the database to see if the vulnerability already exists in Vulnerability table
        existing_vuln = db.query(Vulnerability).filter(Vulnerability.vulnerability_type == vulnerability_type).first()

        # if the vulnerability does not exist, create a new one, otherwise skip and get the vuln_id 
        if existing_vuln:
            vuln_id = existing_vuln.vulnerability_id
        else:
            # copy() is called to ensure that the vuln_data remain the same after calling create_vulnerability
            new_vuln = create_vulnerability(db, vuln_data.copy()) 
            vuln_id = new_vuln.vulnerability_id # get the vuln_id from the new vuln
        
        # iterate through each result in the vulnerability
        for result_data in vuln_data.get('results', []):
            # save each result to the database
            create_result(db, result_data, report.report_id, vuln_id)
    
    # return the report
    return report.report_id


# Function to create a new report and save it to the database Report table
@db_handler # use the decorator  defined above for error handling
def create_report(db: Session, report_data: dict):
    #  creates a new Report object using the report_data,
    report = Report(**report_data)
    # add the report to the database
    db.add(report)
    db.commit() # commit the changes
    db.refresh(report) # refresh the database with the new report 
    return report

# Function to save a new vulnerability to the database Vulnerability table
@db_handler # use the decorator  defined above for error handling
def create_vulnerability(db: Session, vuln_data: dict):
    # remove the results list to insert vuln related data to the db
    vuln_data.pop('results') 
    # create a new Vulnerability object using the vuln_data
    new_vuln = Vulnerability(**vuln_data)
    # add the vuln to the database
    db.add(new_vuln)
    db.commit() # commit the changes
    db.refresh(new_vuln) # refresh the database with the new vuln 
    return new_vuln


# Function to create a new result and save it to the database Result table
@db_handler # use the decorator  defined above for error handling
def create_result(db: Session, result_data: dict, report_id: int, vulnerability_id: int):
    # creates a new Result object using the result data and the provided IDs
    result = Result(
        description=result_data['description'],
        location=result_data['location'],
        report_id=report_id,
        vulnerability_id=vulnerability_id
    )
    db.add(result)
    db.commit()
    db.refresh(result)


# function to retrieves a list of reports from the database
@db_handler # use the decorator  defined above for error handling
def get_all_reports(db: Session):
    # query the database to get a list of reports
    reports = db.query(Report).all()

    # check if there are no reports
    if not reports:
        raise HTTPException(status_code=404, detail="No reports have been uploaded yet. Please upload a report to view details.")

    # initialise the result list with selected information from each report
    result = []
    for report in reports:
        result.append({
            "report_id": report.report_id,
            "contract_name": report.contract_name,
            # convert the date object to a string with format dd-mm-yyyy
            "submission_date": report.submission_date.strftime('%d-%m-%Y'), 
            # convert the time object to a string with format HH:MM AM/PM
            "submission_time": report.submission_time.strftime('%I:%M %p'),
            "number_of_vulnerabilities": report.number_of_vulnerabilities  
        })

    # return the result list containing all the reports
    return result


# Function to retrieve a specific report from a database along with its associated vulnerabilities and results details.
@db_handler # use the decorator  defined above for error handling
def get_report(db: Session, report_id: int):
    # query the database to get a specific report with associated vulnerabilities
    # this is done by joining the Report and Vulnerability tables on the report_id
    report = (
        db.query(Report)
        .filter(Report.report_id == report_id)
        .options(joinedload(Report.vulnerabilities).joinedload(Result.vulnerability))
        .first()
    )

    # check if the report exists
    if report is None:
        raise HTTPException(status_code=404, detail="Report not found. Please upload a report to view details.")

    # prepare the report data to be returned
    report_info = {
        "report_id": report.report_id,
        "contract_name": report.contract_name,
        "submission_date": report.submission_date.strftime('%d-%m-%Y'),
        "submission_time": report.submission_time.strftime('%I:%M %p'),
        "number_of_vulnerabilities": report.number_of_vulnerabilities,
        # initialise vuln_details as dict instead of list to use its vuln_id key
        "vulnerabilities_details": {} 
    }

    # iterate through each vulnerability in the report (this relationship attribute is defined in models.py)
    for result in report.vulnerabilities:
        vuln = result.vulnerability # get the vulnerability attribute of result model

        # check if vulnerability is already in the report_info["vulnerabilities_details"] 
        # this is to prevent duplication of vulnerability 
        # as we are iterating through the result model, not vulnerability model
        if vuln.vulnerability_id not in report_info["vulnerabilities_details"]:
            report_info["vulnerabilities_details"][vuln.vulnerability_id] = {
                "vulnerability_type": vuln.vulnerability_type,
                "impact": vuln.impact,
                "confidence": vuln.confidence,
                "description": vuln.description,
                "recommendation": vuln.recommendation,
                "results": [] # initialise the results list of each vuln
            }

        # add each result to the corresponding vulnerability
        report_info["vulnerabilities_details"][vuln.vulnerability_id]["results"].append({
            "description": result.description,
            "location": result.location
        })

    # convert the vulnerabilities_details dictionary to list object
    report_info["vulnerabilities_details"] = list(report_info["vulnerabilities_details"].values())

    return report_info # return the detailed report information


# function to delete a specific report from the database by its report_id
@db_handler # use the defined decorator for error handling
def delete_report(db: Session, report_id: int):
    # check if the report exists
    report = db.query(Report).filter(Report.report_id == report_id).first()

    # if the report is not found, raise a 404 error
    if report is None:
        raise HTTPException(status_code=404, detail="Report not found")

    # delete associated vuln results data from Result table first
    db.query(Result).filter(Result.report_id == report_id).delete()

    # then delete the report itself
    db.query(Report).filter(Report.report_id == report_id).delete()
    db.commit() # commit the changes
    
    # return a success message
    return {"detail": "Report deleted successfully"}

