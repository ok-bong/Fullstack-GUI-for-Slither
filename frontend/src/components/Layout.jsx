import React from "react";
// import footer and navbar components from other files
import Footer from "./Footer";
import NavBar from "./NavBar";

// Layout component responsible for rendering the common layout structure of every pages
// including nav bar, main content and footer
// this component accepts "children" prop, which represents the content to be rendered inside main content area
const Layout = ({ children }) => {
  return (
    <>
      <NavBar />
      {/* add margin to the body i.e. main element */}
      {/* Tailwind classes: small-screen devices will have smaller margin, but larger screens will have larger margin */}
      <main className="my-16 mx-5 md:mx-20 2xl:mx-44">{children}</main>
      <Footer />
    </>
  );
};

export default Layout;
