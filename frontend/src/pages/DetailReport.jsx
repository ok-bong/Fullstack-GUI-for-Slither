import { toast } from "react-hot-toast";
import React, { useEffect, useState } from "react";
import { BsFillTrashFill } from "react-icons/bs";
import { useParams, Link, useNavigate } from "react-router-dom";
import ReactMarkdown from "react-markdown"; // library for rendering markdown content
import breaks from "remark-breaks"; // remark plugin for handling line breaks
import api from "../api"; // Axios instance for making API requests
import { TITLE1_CSS_CONFIGURATION } from "../constant"; // CSS configuration for title styling
import { BeatLoader } from "react-spinners"; // Loading spinner component from react-spinners library

const DetailReport = () => {
  const { id } = useParams(); // extract 'id' from the route parameters
  const [report, setReport] = useState([]); // state to store the report data
  const [isLoading, setIsLoading] = useState(true); // state for loading spinner
  const [noVulnerabilities, setNoVulnerabilities] = useState(false); // state to track if there are no vulnerabilities
  const [error, setError] = useState(null); // state to handle server connection error msg

  const navigate = useNavigate(); // useNavigate hook from react-router-dom

  // fetch report data
  useEffect(() => {
    // async function to fetch report data from the api
    const getReport = async () => {
      try {
        // make a GET request to API endpoint for each specific report
        const { data } = await api.get(`/reports/${id}`);
        setReport(data); // update the report state with the fetched data
        setIsLoading(false); // make loading spinner disappear after has done fetching
        // set state based on the presence of vulnerabilities in the report, if true then display no vulnerabilities found msg
        setNoVulnerabilities(data.number_of_vulnerabilities === 0);
      } catch (error) {
        // if has 404 status code, meaning no reports has been uploaded yet
        if (error.response && error.response.status === 404) {
          setError("No reports found. Please upload a report to view details.");
        } else {
          // for any other error such as fallback msg or server connection error
          setError(
            error.isServerConnectionError
              ? error.message
              : "An error occurred while fetching reports. Please try again later."
          );
        }
      } finally {
        setIsLoading(false); // set loading spinner to false to indicate that the page has finished loading
      }
    };

    getReport(); // invoke the function to fetch the report data

    // dependency array includes id to ensure useEffect runs when id changes
  }, [id]);

  // render report details
  const renderReportDetails = () => (
    <section>
      <h2 className="text-xl font-bold mb-2 text-blue-600">Report Details</h2>
      <ul className="list-disc pl-6 mb-6">
        <li>
          <span className="font-bold">Contract Name: </span>
          {report.contract_name}
        </li>
        <li>
          <span className="font-bold">Submission Date: </span>
          {report.submission_date}
        </li>
        <li>
          <span className="font-bold">Submission Time: </span>
          {report.submission_time}
        </li>
        <li>
          <span className="font-bold">Number of vulnerabilities: </span>
          {report.number_of_vulnerabilities}
        </li>
      </ul>
    </section>
  );

  // render details of detected vulnerabilities
  const renderVulnerabilityDetails = () => (
    <section>
      <h2 className="text-xl font-bold mb-1 text-blue-600">
        Detected Vulnerability Details
      </h2>
      {/* display a msg if there are no vulnerabilities found */}
      {noVulnerabilities && <p>No vulnerabilities found.</p>}
      {
        // display vulnerability details if the vulnerabilities are present
        report.length !== 0 &&
          // map over the vulnerabilities and render each one
          report.vulnerabilities_details.map(renderVulnerability)
      }
    </section>
  );

  // render each vulnerability and its details
  const renderVulnerability = (v, index) => (
    <section
      key={index}
      className="p-4 mb-4 border-b-2 last-of-type:border-none"
    >
      <h3 className="text-lg font-bold mb-2">
        {/* display the vulnerability number and its result count */}
        Vulnerability {index + 1} ({v.results.length}
        {v.results.length === 1 ? " result" : " results"})
      </h3>
      {/* display a list of details for the vulnerability */}
      <ul className="list-disc pl-6 mb-2">
        {/* display each vulnerability detail as a list item */}
        <li>
          <span className="font-bold">Vulnerability type: </span>
          {/* use react-markdown to convert markdown format stored in the db to html element */}
          <ReactMarkdown
            components={{ a: MarkdownLink }} // set anchor tag of react-markdown to be clickable
            children={v.vulnerability_type}
          />
        </li>
        <li>
          <span className="font-bold">Impact level: </span>
          <ReactMarkdown components={{ a: MarkdownLink }} children={v.impact} />
        </li>
        <li>
          <span className="font-bold">Confidence level: </span>
          <ReactMarkdown
            components={{ a: MarkdownLink }} // set anchor tag of react-markdown to be clickable
            children={v.confidence}
          />
        </li>
        <li>
          <span className="font-bold">Description: </span>
          <ReactMarkdown
            components={{ a: MarkdownLink }} // set anchor tag of react-markdown to be clickable
            children={v.description}
          />
        </li>
        <li>
          <span className="font-bold">Recommendation: </span>
          <ReactMarkdown
            components={{ a: MarkdownLink }} // set anchor tag of react-markdown to be clickable
            children={v.recommendation}
          />
        </li>
      </ul>
      <h4 className="font-bold text-lg">Results:</h4>
      {/* render each result and its details  */}
      <ul className="list-none pl-6">{v.results.map(renderResult)}</ul>
    </section>
  );

  // render each result and its details
  const renderResult = (result, resultIndex) => (
    <li key={resultIndex}>
      <div>
        <span className="font-bold text-blue-500">
          Result {resultIndex + 1}:
        </span>
        <ul className="list-disc pl-6">
          <li>
            <span className="font-bold">Description: </span>
            <ReactMarkdown
              components={{ a: DisabledLink }} // set anchor tag of react-markdown to be not clickable
              remarkPlugins={[breaks]} // use remark plugin for handling line breaks
              children={result.description}
            />
          </li>
          <li>
            <span className="font-bold">Location: </span>
            {result.location}
          </li>
        </ul>
      </div>
    </li>
  );

  // disabled link component to be used in the result description as these links should be not clickable and has styling
  const DisabledLink = ({ children }) => (
    <span className="font-bold underline underline-offset-2 decoration-blue-500">
      {children}
    </span>
  );

  // markdown link that has styling to be used in vulnerability description or recommendation so the link is easier to differentiate
  const MarkdownLink = ({ href, children }) => (
    <a
      href={href} // set the 'href' attribute to the value provided in the 'href' prop
      className="text-blue-600 hover:underline"
      target="_blank" // to open link in a new tab
      rel="noopener noreferrer" // for security reasons when opening in a new tab
    >
      {/* the content of the link is specified by the children prop. */}
      {children}
    </a>
  );

  // function to handle delete the report
  const handleDeleteReport = async () => {
    try {
      await api.delete(`/reports/${id}`); // call the api to delete the report
      // show success notification
      toast.success("Report deleted successfully.", { persistent: true }); // make the toast persistent even after page redirection

      // redirect the user to the Report History page after deletion
      navigate("/reports");
    } catch (error) {
      // error handling
      console.error("Error deleting report:", error);
    }
  };

  return (
    <div>
      <div className="flex flex-col items-center justify-center">
        {/* display the title with custom margin */}
        <h1 className={`${TITLE1_CSS_CONFIGURATION} mb-3`}>
          Detail Report {id}
        </h1>
        {/*  a link to return to report history page with custom styling */}
        <div className="flex items-center justify-normal flex-row mb-3">
          <Link
            to="/reports"
            className="px-4 py-2 mx-3 bg-blue-500 text-l text-white rounded-full hover:bg-blue-600 transition-colors duration-200"
          >
            Report History
          </Link>
          {/* only show delete button if there is no error */}
          {!error && (
            <button
              onClick={handleDeleteReport}
              className="px-4 py-2 bg-red-500 text-white rounded-full hover:bg-red-600 transition-colors duration-200"
            >
              {/* trash icon indicating delete action */}
              <BsFillTrashFill className="text-xl" />
            </button>
          )}
        </div>
      </div>

      {/* display server connection error message or other error msg if exists */}
      {error && (
        <div className="text-red-600 flex justify-center items-center mb-3 flex-col text-center">
          {error}
          <p>
            <Link className="text-blue-600 hover:underline" to="/">
              Go to Homepage
            </Link>
          </p>
        </div>
      )}
      {/* display loader component if data is loading */}
      {isLoading && (
        <div className="text-center mt-4">
          {/* Display a loading spinner */}
          <BeatLoader color="#1d4ed8" loading={true} />
          <p>Loading...</p>
        </div>
      )}

      {/* display report details if there is no error and data is not loading */}
      {!isLoading && !error && renderReportDetails()}

      {/* display vulnerability details if there is no error and data is not loading */}
      {!isLoading && !error && renderVulnerabilityDetails()}
    </div>
  );
};

export default DetailReport;
