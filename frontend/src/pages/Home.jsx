import { Link } from "react-router-dom"; // import Link component of react-router-dom to enable routing between pages
import Image from "../assets/bitcoin.jpg"; //  Reference: https://unsplash.com/photos/NHRM1u4GD_A
// import icons from https://react-icons.github.io/react-icons/
import { TbReport } from "react-icons/tb";
import { MdAnalytics, MdMobileFriendly } from "react-icons/md";
import { BsSpeedometer } from "react-icons/bs";

// import other components
import Hero from "../components/Hero";
import Uploader from "../components/Uploader";

// GridItem component to be used in the 2nd section of this page for reuse purpose
// Because this component is used on this page only, no need to put this in separate file
const GridItem = ({
  Icon, // an icon to be passed as a prop to this component.
  title, // title or heading text
  paragraph, // body text of this component
}) => {
  return (
    <div className="my-3">
      <h3 className=" flex justify-center items-center text-center text-2xl text-cyan-500 font-extrabold lg:text-4xl">
        <Icon className="mr-3" /> {title}
      </h3>
      <p className="mt-3 text-center">{paragraph}</p>
    </div>
  );
};

// home page: this is where users can upload their smart contract files for auditing and other relevant information
const Home = () => {
  return (
    <div>
      {/* Heading with decoration text using Tailwind CSS classes */}
      <h1 className="text-center text-3xl font-extrabold sm:text-4xl lg:text-5xl mb-4">
        Welcome to
        <span className="ml-3 underline underline-offset-3 decoration-blue-600 decoration-8 ">
          Cyber Tech
        </span>
      </h1>
      {/* introduction paragraph */}
      <p className="text-center font-normal mb-4">
        Join <span className="text-blue-600">Cyber Tech</span>: Auditing smart
        contracts for a secure blockchain. <br />
        For more information, please visit
        <Link
          to="/about"
          className="text-blue-600 hover:text-blue-900 font-semibold hover:underline mx-1"
        >
          About Us
        </Link>
      </p>
      {/* File Uploader component that allows the user to upload smart contract files */}
      <Uploader />
      {/* 2nd section to display the reasons why the users should choose our website */}
      <h2 className="text-center text-2xl font-extrabold sm:text-3xl lg:text-4xl mt-10 mb-5">
        Why Choose Cyber Tech?
      </h2>
      {/* Tailwind CSS grid allowing responsiveness */}
      {/* Grid: 1 column on small screen, 2 columns on medium screen */}
      <section className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* use Grid Item component defined above and passing various props to it for customisation */}
        <GridItem
        // icon from react-icons library
          Icon={TbReport}
          title="Detailed Reports"
          paragraph="Receive detailed and easy-to-understand reports, outlining
            identified vulnerabilities, their severity levels, and recommended fixes."
        />
        <GridItem
          Icon={BsSpeedometer}
          title="Fast and Efficient"
          paragraph="Our smart contract auditing process is quick, allowing you to secure your projects without any delays."
        />
        <GridItem
          Icon={MdAnalytics}
          title="Accurate Analysis"
          paragraph="Our static analysis tool will analyse your smart contracts, ensuring
            even the tiniest vulnerabilities are detected, guaranteeing the
            robustness of your smart contract code."
        />
        <GridItem
          Icon={MdMobileFriendly}
          title="Mobile Flexibility"
          paragraph="Our device-friendly platform empowers you to perform audits, review
            reports directly from your mobile device. No matter where you are,
            your project's security is within reach."
        />
      </section>
      {/* Hero component imported from another file with different props for customisation */}
      <Hero
        image={Image}
        heading="Smart Contract"
        alt="Smart Contract"
        paragraph="Having trouble wondering if your code is safe? Try out now with our new project that can help you determine if your product is safe or not with 99.999% accuracy."
      />
    </div>
  );
};

export default Home;
