// AboutUs component renders the content for the AboutUs page

import { TITLE1_CSS_CONFIGURATION } from "../constant"; // import global styles for titles
// import other components
import Button from "../components/Button";
// import icons from react-icons library
import { AiFillCode, AiOutlineAudit, AiFillBug } from "react-icons/ai";
import { SiHiveBlockchain } from "react-icons/si";
// import assets e.g. images
import Image1 from "../assets/security.svg"; // Reference: https://undraw.co/illustrations
import dev1 from "../assets/dev1.png"; // Reference: https://randomuser.me/photos
import dev2 from "../assets/dev2.png"; // Reference: https://randomuser.me/photos
import dev3 from "../assets/dev3.png"; // Reference: https://randomuser.me/photos

// Reusable Card component that takes 3 props to render a styled card
// Because this component is used on this page only, no need to put this in separate file
const Card = ({ icon, title, description }) => {
  return (
    <section className="p-3 flex m-2 rounded-xl scale-90 hover:scale-100 hover:shadow-xl transition bg-gray-100 duration-500">
      <div className="text-white flex items-center justify-center rounded-lg bg-blue-500 h-12 w-12 md:h-10 md:w-10 mr-4">
        {/* the icon to be displayed in the card */}
        {icon}
      </div>
      {/* Flexbox to align child elements vertically i.e. flex-col */}
      <div className="flex flex-col">
        {/* title and description to be displayed in the card */}
        <p className="font-medium text-gray-900">{title}</p>
        <p className="text-sm mt-1 text-gray-600">{description}</p>
      </div>
    </section>
  );
};

// Box component that takes 3 props will be displayed in the "Meet our team" section
// Because this component is used on this page only, no need to put this in separate file
const Box = ({ name, id, image, alt, desc }) => {
  return (
    <figure className="rounded-lg bg-indigo-100 p-5 mx-5 md:mx-0">
      <div className="flex flex-col justify-center items-center mb-2">
        <img
          className="h-32 w-32 inline-flex items-center justify-center p-3 bg-blue-500 rounded-full"
          // image source for the box
          src={image}
          // alt text for the image
          alt={alt}
        />
        {/* display student's name and id */}
        <h3 className="text-lg font-medium text-gray-900">{name}</h3>
        <p className="text-gray-500">{id}</p>
      </div>
      {/* description of each student */}
      <p className="text-gray-400 text-center">{desc}</p>
    </figure>
  );
};

// AboutUs page that uses the above components
const AboutUs = () => {
  // style variable that holds Tailwind CSS classes to reduce repetitive code
  const taglineStyle = "tracking-wider font-semibold text-blue-600 uppercase";
  const headingStyle =
    "tracking-tight text-3xl font-extrabold text-gray-900 lg:text-4xl";

  return (
    <div>
      <h1 className={TITLE1_CSS_CONFIGURATION}>About Us</h1>
      {/* 1st grid */}
      <section className="grid m-4 my-16 mb-14 lg:grid-cols-2 gap-3 place-items-center">
        <img src={Image1} alt="Smart contract security" />
        <div className="flex flex-col">
          <p className={taglineStyle}>Introducing</p>
          <h2 className={headingStyle}>Smart Contract Auditing</h2>
          <p className="text-gray-400">
            Elevate your smart contract security by using our tool to identify
            security issues and inefficient coding practices that can lead to
            your application being hacked.
          </p>
          <Button className="mt-3 mx-0" content="Try now" />
        </div>
      </section>

      {/* 2nd grid */}
      <hgroup className="text-center mt-20">
        <p className={taglineStyle}>Blockchain security</p>
        <h2 className={headingStyle}>Securing smart contracts</h2>
      </hgroup>
      <section className="grid md:grid-cols-2 lg:grid-cols-4 gap-3">
        {/* Use the above Card component with different props (icon, title, description) for customisation but with same style */}
        <Card
          icon={<AiFillCode className="text-2xl" />}
          title="Code refinement"
          description="Optimise your code by eliminating errors"
        />
        <Card
          icon={<AiOutlineAudit className="text-2xl" />}
          title="Audit"
          description="Reliable with comprehensive auditing"
        />
        <Card
          icon={<AiFillBug className="text-2xl" />}
          title="Bug-free"
          description="Detect bugs and vulnerabilities"
        />
        <Card
          icon={<SiHiveBlockchain className="text-2xl" />}
          title="Blockchain"
          description="Safeguarding your blockchain projects"
        />
      </section>

      {/* 3rd grid */}
      <hgroup className="text-center mt-20">
        <p className={taglineStyle}>Meet</p>
        <h2 className={headingStyle}>Our team</h2>
      </hgroup>
      {/* implementation of the above Box component with different props (student name,student id, image, alt for image, description for each) for customisation */}
      <section className="grid my-3 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <Box
          name="Henry Le"
          id="103795561"
          image={dev1}
          alt="Henry Le"
          desc="Greetings, this is Henry, a 20-year old student at Swinburne University of Technology, studying Computer Science with a major in Cybersecurity."
        />
        <Box
          name="Thang Dinh"
          id="103522316"
          image={dev2}
          alt="Thang Dinh"
          desc="Hi I'm developing this website too!"
        />
        <Box
          name="Jade Hoang"
          id="103795587"
          image={dev3}
          alt="Jade Hoang"
          desc="I'm a student at Swinburne University of Technology, studying Computer Science with a major in Cybersecurity. I'm currently in my second year, second semester."
        />
      </section>
    </div>
  );
};

export default AboutUs; // export the AboutUs component to be imported into other components
