/* Group 2-25
  Group set 2: cybersecurity
  Team member: 
    Thang Dinh - 103522316
    Henry Le - 103795561 
    Jade Hoang - 103795587 */

import { Toaster } from "react-hot-toast"; // for notification
import { Routes, Route } from "react-router-dom";
import { BiUpArrowAlt } from "react-icons/bi";
import Home from "./pages/Home";
import AboutUs from "./pages/AboutUs";
import ReportHistory from "./pages/ReportHistory";
import NotFound from "./pages/NotFound";
import Layout from "./components/Layout";
import DetailReport from "./pages/DetailReport";

const App = () => {
  // function to scroll the page to the top with a smooth animation.
  const handleScrollToTop = () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  return (
    // wrap the whole application in the Layout component to have consistent layout across all pages
    <Layout>
      {/* Routes component of react-router-dom library to map the different pages and allow multi-page React application */}
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<AboutUs />} />
        <Route path="/reports" element={<ReportHistory />} />
        <Route path="/reports/:id" element={<DetailReport />} />
        {/* this route matches any path that hasn't been matched by any other route and renders the NotFound component  */}
        <Route path="*" element={<NotFound />} />
      </Routes>

      {/* scroll to top button */}
      <button
        onClick={handleScrollToTop}
        // make the button fixed at the bottom right corner of the page
        className="fixed bottom-4 right-4 bg-blue-400 text-white px-1 py-1 rounded-full hover:bg-blue-500 transition-colors duration-200"
      >
        {/* up arrow icon indicating scroll to top action */}
        <BiUpArrowAlt className="text-3xl" />
      </button>

      {/* toaster component of react-hot-toast library to display notifications like success deletion */}
      <Toaster></Toaster>
    </Layout>
  );
};

export default App;
