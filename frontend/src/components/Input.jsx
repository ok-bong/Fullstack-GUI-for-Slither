import React from "react";

// Form input component 
const Input = ({
  htmlFor,  // "for" attribute value of the label associated with the input
  type,  // type of input (e.g., "text", "email", "password")
  placeholder, // placeholder text to display when the input is empty
  className,  // additional CSS classes to be applied to the input
  name,  // "name" attribute of the input
  id, // "id" attribute of the input
  value,  // the current value of the input
  onChange, // event handler function to be called when the input value changes
  isRequired = true  // whether the input is required (defaults to true if not provided)
}) => {
  return (
    <div>
      <label htmlFor={htmlFor}></label>
      <input
      // Tailwind CSS classes for styling the input field e.g. add border, width of the input field to 100% of its container, change style when the input is focused etc.
        className={`px-3 py-2 my-2 border w-full relative rounded-lg border-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500 ${className}`}
        type={type}
        placeholder={placeholder}
        required={isRequired}
        name={name}
        id={id}
        value={value}
        onChange={onChange}
      />
    </div>
  );
};

export default Input;
