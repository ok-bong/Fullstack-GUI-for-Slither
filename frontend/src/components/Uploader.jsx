import React, { useState } from "react";
import {toast} from "react-hot-toast";
import { BeatLoader } from "react-spinners"; // for spinner component while file is being uploaded
import api from "../api";
import { useNavigate } from "react-router-dom";

// File uploader component allows the user to upload smart contract files
const Uploader = () => {
  const [selectedFile, selectFile] = useState(null); // store the selected file using useState
  const [error, setError] = useState(null); // for error msg if exists
  const [isLoading, setIsLoading] = useState(false); // for keeping track of the spinner loading state

  // get the navigate function from react-router-dom for redirection
  const navigate = useNavigate();

  // function to handle tasks when file is uploaded
  const handleFileUpload = async (e) => {
    e.preventDefault(); // prevent default behavior of the event

    // reset the error state, so that the error msg disappears when user click upload button again
    setError(null);

    // check if the user has uploaded a file before clicking upload button
    if (!selectedFile) {
      setError("Please select a file before uploading.");
      return; // skip the rest of the function if no file is selected
    }

    // client side validation to check if the file has a valid extension
    // note: server side fastapi also has this validation for integrity check
    const allowedExtensions = ["sol"];
    // get the file extension from the selected file by splitting it into an array and get the last element of the array
    const fileExtension = selectedFile.name.split(".").pop().toLowerCase();
    // check if the file has a valid extension
    if (!allowedExtensions.includes(fileExtension)) {
      setError(
        "Invalid file extension. Please upload only .sol files for auditing."
      );
      return; // skip the rest of the function if the file has an invalid extension
    }

    const formData = new FormData(); // create a new FormData object
    formData.append("contract", selectedFile); // append the selected file to the FormData object

    try {
      setIsLoading(true); // set loading to true when starting the upload

      // make a POST request to the API endpoint
      const response = await api.post("/upload_contract", formData);

      if (response.status === 201) {
        // show success notification
        toast.success("Your smart contract has been audited successfully.");
        // on successful upload (status code 201), navigate to the detailed report page
        // response.data.report_id refer to the report_id returned by fastapi endpoint
        navigate(`/reports/${response.data.report_id}`);
      } else if (response.status === 422) {
        // if has unprocessable entity 422 status code, set the error message
        setError("Invalid input data encoding format. Please try again.");
      }
    } catch (e) {
      // catch any other errors
      if (e.isServerConnectionError) {
        // server connection error that has been set globally in api.js file
        setError(e.message); // e.message refer to the message defined in api.js file
      } else {
        // other error msg from the fastapi server or fallback msg
        setError(
          e.response?.data?.detail ||
            "An error occurred while processing the file"
        );
      }
    } finally {
      setIsLoading(false); // set loading to false when the upload is complete
    }
  };

  // function to update the file state
  const handleFileSelection = (e) => {
    // e.target refers to the DOM element triggered the event (input element)
    // e.target.files is an object containing selected files
    const file = e.target.files[0];

    // set the file state to the first selected file in the e.target.files obj
    selectFile(file);
    // reset the error msg when a new file is selected
    setError(null);
  };

  // function to handle drag over event for drag and drop file behaviour
  const handleDragOver = (e) => {
    e.preventDefault(); // prevent default behavior of the event
  };

  // function to handle drop event for drag and drop file behaviour
  const handleDrop = (e) => {
    e.preventDefault(); // prevent default behavior of the event

    // get the dropped file from the event
    const file = e.dataTransfer.files[0];

    // set the file state to the dropped file
    selectFile(file);

    // reset the error state, so that the error msg disappears when user upload a new file
    setError(null);
  };

  return (
    <form
      id="upload-form"
      className="flex flex-col py-6 px-9"
      onSubmit={handleFileUpload}
      encType="multipart/form-data"
    >
      <div
        className="flex justify-center mb-8"
        onDragOver={handleDragOver}
        onDrop={handleDrop}
      >
        <label
          htmlFor="upload-file"
          className="w-full lg:w-1/2 relative min-h-[200px] items-center justify-center rounded-md border-2 border-[#e0e0e0] p-12 text-center hover:bg-gray-100 hover:border-dashed"
        >
          {/* if the file has been uploaded, display the file name */}
          {selectedFile !== null ? (
            <div>
              <p id="status-notification-file">{selectedFile.name}</p>
            </div>
          ) : (
            // otherwise, display a placeholder text telling the user to upload a file
            <div>
              <span className="mb-2 block text-xl font-semibold text-[#07074D]">
                Drop files here
              </span>
              <span className="mb-2 block text-base font-medium text-[#6B7280]">
                Or
              </span>
              <span className="items-center inline-block transition-colors duration-200 bg-blue-500 hover:bg-blue-600 text-white hover:text-gray-200 rounded py-2 px-4">
                Browse
              </span>
            </div>
          )}
        </label>

        {/* upload file input */}
        <input
          className="sr-only"
          id="upload-file"
          type="file"
          onChange={handleFileSelection}
        ></input>
      </div>

      <div className="flex flex-col justify-center items-center">
        {/* conditionally render the spinner or upload button based on the loading state */}
        {isLoading ? (
          <div className="flex flex-col justify-center items-center">
            <BeatLoader color="#1d4ed8" loading={true} />
            <p>Your file is being processed. Please wait...</p>
          </div>
        ) : (
          // submit button
          <button
            className="w-full lg:w-1/2 items-center inline-block transition-colors duration-200 bg-blue-500 hover:bg-blue-600 text-white hover:text-gray-200 rounded py-2 px-4"
            type="submit"
          >
            Upload
          </button>
        )}
        {/* display error msg if exists */}
        {error && (
          <div className="text-red-500 mt-2 flex justify-center items-center text-center">
            {error}
          </div>
        )}
      </div>
    </form>
  );
};

export default Uploader;
