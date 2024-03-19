import React from "react";
import { Link } from "react-router-dom";
import { AiFillHome } from "react-icons/ai";
import Image from "../assets/not-found.svg";

// This is not found page that displays 404 error message when user access a page that does not exist
const NotFound = () => {
  return (
    // use Flexbox to display the image and paragraph horizontally in larger screens, vertically in smaller screens
    <figure className="flex justify-around items-center flex-col lg:flex-row">
      <img src={Image} alt="Not found" className="w-1/2" />
      <section className="grid place-items-center content-center sm:my-2">
        <h1 className="font-bold text-3xl lg:text-6xl text-blue-500">Oops!</h1>
        <p className=" font-bold mb-2 text-2xl my-2 lg:text-3xl text-red-500">
          Page not found
        </p>
        {/* Button that links to home page using Link component of react-router-dom  */}
        <Link
          to="/"
          className="px-5 py-2 mt-2 rounded-full flex items-center font-bold text-blue-100 bg-blue-600 hover:bg-blue-700 transition-colors duration-200"
        >
          {/* use icon from react-icons library */}
          <AiFillHome className="mr-2 text-xl" />
          Back to home
        </Link>
      </section>
    </figure>
  );
};

export default NotFound; // export the NotFound page to be used in other files
