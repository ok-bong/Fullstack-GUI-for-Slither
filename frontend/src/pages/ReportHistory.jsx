import { toast } from "react-hot-toast";
import { TITLE1_CSS_CONFIGURATION } from "../constant";
import { useEffect, useState } from "react";
import Search from "../components/Search";
import ReportList from "../components/ReportList";
import api from "../api";
import { BeatLoader } from "react-spinners";
import { Link } from "react-router-dom";

// this component represents a page that displays a list of reports
const ReportHistory = () => {
  // state variables to manage various aspects of the component's state
  const [reports, setReports] = useState([]); // to manage report data
  const [query, setQuery] = useState(""); // to manage search query, by default, the query is empty
  const [sortBy, setSortBy] = useState("submission_date"); // to manage sort field, by default, sort by submission date field
  const [orderBy, setOrderBy] = useState("desc"); // to manage sort order, by default, the report list is displayed in ascending order
  const [error, setError] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  // trigger after the component is mounted
  useEffect(() => {
    getAllReportData();
  }, []);

  // function to check if a report matches the current query
  const matchesQuery = (report) => {
    // filter reports based on various fields using the "query" state variable
    // convert both report field and query to lower case for case-insensitive search
    // check if each field e.g. contract name, submission time, etc. contains the query
    return (
      report.report_id.toString().includes(query) ||
      report.contract_name.toLowerCase().includes(query.toLowerCase()) ||
      report.number_of_vulnerabilities.toString().includes(query) ||
      report.submission_date.includes(query) ||
      report.submission_time.toLowerCase().includes(query.toLowerCase())
    );
  }

  const sortReports = (a, b) => {
    // determine sorting order based on orderBy value
    const sortingOrder = orderBy === "asc" ? -1 : 1;
  
    // if sorting by submission_date field
    if (sortBy === "submission_date") {
      // convert submission dates and times to Date objects for comparison
      const dateA = new Date(`${a.submission_date} ${a.submission_time}`);
      const dateB = new Date(`${b.submission_date} ${b.submission_time}`);
  
      // compare dates
      if (dateA < dateB) {
        return 1 * sortingOrder; // return 1 for ascending order, -1 for descending order
      }
      if (dateA > dateB) {
        return -1 * sortingOrder;  // return -1 for ascending order, 1 for descending order
      }
  
      // if dates are the same, sort by report_id to display the latest report on top
      return (b.report_id - a.report_id) * sortingOrder;
    } else {
      // default sorting by other fields if not sorting by submission_date
      // compare other fields in ascending or descending order based on sortingOrder
      return a[sortBy].toString().toLowerCase() < b[sortBy].toString().toLowerCase()
        ? 1 * sortingOrder // sort in ascending order
        : -1 * sortingOrder; // sort in descending order
    }
  };
  

  // get all the report each time the page is rendered
  async function getAllReportData() {
    try {
      setIsLoading(true); // set loading spinner to true to indicate that the page is loading
      const reportData = await api.get("/reports/"); // get all reports from the database api
      setReports(reportData.data); // update the report state with the fetched data
      setError(null); // reset the error state
    } catch (error) {
      // if has 404 status code, meaning no report with given id found
      if (error.response && error.response.status === 404) {
        setError(
          "No reports have been uploaded yet. Please upload a report to view details."
        );
      } else {
        // for any other error as fallback msg and server connection error
        setError(
          error.isServerConnectionError
            ? error.message
            : "An error occurred while fetching reports. Please try again later."
        );
      }
    } finally {
      setIsLoading(false); // set loading spinner to false to indicate that the page has finished loading
    }
  }

  // delete a report from the database
  const deleteAReport = async (id) => {
    await api.delete("/reports/" + id); // delete the report from the database api
  };

  // filter and sort the reports based on search and sort criteria
  const filteredReports = () => {
    if (Array.isArray(reports)) {
      // check if reports is an array to avoid errors
      return reports.filter(matchesQuery).sort(sortReports); // filter and sort the reports
    } else {
      return []; // return an empty array if reports is not an array
    }
  };

  // function to handle report deletion
  const handleDelete = async (report_id) => {
    try {
      // delete report from the database
      await deleteAReport(report_id);

      // filtering out the deleted report
      const updatedReports = reports.filter(
        (report) => report.report_id !== report_id
      );
      // update the reports state to the filtered report
      setReports(updatedReports);

      // show success notification
      toast.success("Report deleted successfully.");
    } catch (error) {
      console.error("An error occurred:", error);
    }
  };

  return (
    <div>
      {/* Title using global styles */}
      <h1 className={TITLE1_CSS_CONFIGURATION}>Report History</h1>
      {/* Search component */}
      <Search
        query={query}
        onQueryChange={(newQuery) => setQuery(newQuery)} // handle query changes
        sortBy={sortBy}
        onSortByChange={(newSortBy) => setSortBy(newSortBy)} // handle sort field changes
        orderBy={orderBy}
        onOrderByChange={(newOrderBy) => setOrderBy(newOrderBy)} // handle sort order changes
      />

      {isLoading && (
        <div className="flex flex-col justify-center items-center">
          {/* Display a loading spinner */}
          <BeatLoader color="#1d4ed8" loading={true} />
          <p>Loading...</p>
        </div>
      )}

      {/* check if there is an error */}
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

      {/* Display list of reports if there is no error and data is not loading */}
      {!isLoading && !error && (
        <ReportList reports={filteredReports()} onDelete={handleDelete} />
      )}
    </div>
  );
};

export default ReportHistory;
