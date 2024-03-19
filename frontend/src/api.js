// This file handles API calls from the frontend, 
// providing a centralised place to manage communication with the backend through axios

import axios from "axios";

// add connection to FastAPI, creating an axios instance
const api = axios.create({
  baseURL: "http://localhost:8000", // fastapi base url as it runs on port 8000
});

// interceptor for handling responses and errors
// If there is a server connection error, 
// it throws a custom error object with a flag indicating it is a server connection error. 
// otherwise, it throws the original error
api.interceptors.response.use(
  (response) => {
    // return a successful response back to the calling service
    return response;
  },
  (error) => {
    if (!error.response) {
      // global handle server connection errors
      const serverConnectionError = new Error(
        "Server connection error. We are currently experiencing connectivity issues with the server. Please try again later."
      );
      serverConnectionError.isServerConnectionError = true; // server connection error flag
      throw serverConnectionError;
    } else {
      // throw the original error
      throw error;
    }
  }
);

export default api;
