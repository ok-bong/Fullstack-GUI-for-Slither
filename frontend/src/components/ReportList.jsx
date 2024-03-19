import { Link } from "react-router-dom";

// this component displays a list of audit reports
const ReportList = ({ reports, onDelete }) => {
  const tableCategories = [
    "Report ID",
    "Contract name",
    "Submission date",
    "Submission time",
    "Number of vulnerabilities",
    "Actions",
  ];

  return (
    <div className="flex justify-center">
      {/* display the table only if there are reports */}
      {reports.length === 0 ? (
        <p className="text-gray-500">No reports found</p>
      ) : (
        <div className="w-full">
          {/* Desktop view will display a single table for all reports */}
          <table className="hidden w-full md:table">
            <thead>
              {/* looping through the tableCategories list for table headers */}
              <tr>
                {tableCategories.map((category, index) => (
                  <th key={index} className="px-4 py-2">
                    {category}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {/* looping through all the reportData records for table body */}
              {reports.map((record, index) => (
                <tr key={index} className="even:bg-slate-100 text-center">
                  <td className="border px-4 py-2">{record.report_id}</td>
                  <td className="border px-4 py-2">{record.contract_name}</td>
                  <td className="border px-4 py-2">{record.submission_date}</td>
                  <td className="border px-4 py-2">{record.submission_time}</td>
                  <td className="border px-4 py-2">
                    {record.number_of_vulnerabilities}
                  </td>
                  <td className="border px-4 py-2 flex flex-col lg:flex-row justify-center">
                    {/* Link to detailed report page */}
                    <Link
                      className="text-blue-500 hover:underline"
                      to={"/reports/" + record.report_id}
                    >
                      Details
                    </Link>
                    {/* delete button */}
                    <button
                      className="text-red-500 lg:ml-4 hover:underline mt-1 lg:mt-0"
                      onClick={() => onDelete(record.report_id)}
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          {/* Mobile view will display the list format, on medium device, this is hidden */}
          <div className="md:hidden">
            {/* looping through all the reportData records for table body */}
            {reports.map((record, index) => (
              <div
                key={index}
                className="border px-4 py-2 mb-4 even:bg-slate-100"
              >
                <p>
                  <span className="font-bold">Report ID: </span>
                  {record.report_id}
                </p>
                <p>
                  <span className="font-bold">Contract Name: </span>
                  {record.contract_name}
                </p>
                <p>
                  <span className="font-bold">Submission Date: </span>
                  {record.submission_date}
                </p>
                <p>
                  <span className="font-bold">Submission Time: </span>
                  {record.submission_time}
                </p>
                <p>
                  <span className="font-bold">Number of vulnerabilities: </span>
                  {record.number_of_vulnerabilities}
                </p>
                <div>
                  {/* Link to detailed report page */}
                  <Link
                    className="text-blue-500"
                    to={"/reports/" + record.report_id}
                  >
                    Details
                  </Link>
                  {/* delete button */}
                  <button
                    className="text-red-500 ml-5"
                    onClick={() => onDelete(record.report_id)}
                  >
                    Delete
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default ReportList;
