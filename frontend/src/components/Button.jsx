import React from "react";
// import Link component from react router DOM library to allow linking to different pages
import { Link } from "react-router-dom";
// import icons from react icons library
import { BsCodeSlash } from "react-icons/bs";

// call-to-action button component that is used in multiple places
// this component accept 2 props that can be passed when being used for customisation

const Button = ({ content, className }) => {
  // return a link element that wraps a button element
  return (
    // Link to homepage where the uploader is located
    <Link className="flex justify-center lg:justify-start" to="/">
      {/* className props so that we can add additional CSS classes to be applied to the button */}
      <button
        className={`rounded-full m-2 bg-blue-500 hover:bg-blue-700 py-2 px-4 text-white font-bold inline-flex items-center transition-colors duration-200 ${className}`}
      >
        {/* use react icons and add tailwind classes for styling */}
        <BsCodeSlash className="mr-3 text-xl font-bold" />
        {/* the content to be displayed inside the button */}
        {content}
      </button>
    </Link>
  );
};

export default Button; // export the Button component to be used in other files
