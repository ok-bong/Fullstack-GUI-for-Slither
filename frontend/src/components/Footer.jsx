import Logo from "./Logo";
import { Link } from "react-router-dom"; // import Link from react-router-dom to enable routing
import {
  AiFillFacebook,
  AiOutlineInstagram,
  AiFillGithub,
} from "react-icons/ai"; // import icons from react-icons library
import { BsMailbox, BsFillTelephoneFill } from "react-icons/bs";
import { navLinks } from "../constant";

// Footer component to be displayed in every pages
const Footer = () => {
  // style for list item to be used in the footer and reduce repetitive code
  const listItemStyle =
    "text-gray-400 hover:text-white transition-colors duration-200 mx-4";

  // render nav links function that maps over the navLinks array
  const renderNavLinks = () => {
    // return a list of React components, with each representing a nav link
    return navLinks.map((link, index) => (
      <li key={index} className={listItemStyle}>
        <Link
          to={link.path}
          className="px-3 py-2 flex items-center text-white hover:opacity-75"
        >
          {link.name}
        </Link>
      </li>
    ));
  };

  // return the footer component with logo, nav links, buttons and social media sections
  return (
    <footer className="bg-gray-800 w-full py-2">
      {/* Logo and call-to-action button section */}
      <section className="max-w-screen-xl px-4 mx-auto flex flex-col lg:flex-row justify-between items-center">
        <div className="flex flex-col">
          <Logo className="flex justify-center lg:justify-start mb-[-9px]" />
          <p className="text-white mb-4 ml-3 text-xl font-bold italic">
            Secure your smart contract code now
          </p>
        </div>
        <ul className="flex flex-col lg:flex-row mx-1.5 my-3 text-lg font-light justify-start">
          {/* call above function */}
          {renderNavLinks()}
        </ul>
        {/* contact information section */}
        <section>
          <p className="flex flex-row text-white items-center my-3">
            {/* use the BsFillTelephoneFill icon from react-icons */}
            <BsFillTelephoneFill className="text-1.5xl mx-5" /> (01) 2345 6789
          </p>
          <p className="flex flex-row text-white items-center">
            {/* use the BsFillTelephoneFill icon from react-icons */}
            <BsMailbox className="text-1.5xl mx-5" /> group2-25@gmail.com
          </p>
        </section>
      </section>

      <hr className="mt-7 mb-3" />
      {/* use flexbox to align social media links section */}
      <section className="flex justify-center py-3">
        {/* Link each social media icon, for visual purpose */}
        <Link className={listItemStyle} to="#">
          <AiFillFacebook className="text-3xl" />
        </Link>
        <Link className={listItemStyle} to="#">
          <AiOutlineInstagram className="text-3xl" />
        </Link>
        <Link className={listItemStyle} to="#">
          <AiFillGithub className="text-3xl" />
        </Link>
      </section>
    </footer>
  );
};

export default Footer; // export footer component to be used in other components
