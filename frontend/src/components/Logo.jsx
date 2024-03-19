import React from "react";
// Link component of react-router-dom to create clickable links and handle routing
import { Link } from "react-router-dom";
// import icons from react-icons library
import { MdOutlineSecurity } from "react-icons/md";

// Logo component to be displayed in the header and footer
const Logo = ({ className }) => {
  // this component accepts className props so that it can be styled further when being used in other components
  return (
    <div className={`text-2xl inline-block mr-4 py-2 text-white ${className}`}>
      {/* Link the logo to home page */}
      <Link to="/" className="flex items-center py-5 px-2 ">
        <MdOutlineSecurity className="h-10 w-10 mr-3 text-blue-500" />
        <span className="font-bold text-white">Cyber Tech</span>
      </Link>
    </div>
  );
};

export default Logo; // export the Logo component to be imported into other components
