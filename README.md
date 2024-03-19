# Smart Contract Audit System

The objective of this project is to develop a web platform for auditing Solidity smart contracts using Slither. Slither serves as a static analysis framework/tool specifically designed for Solidity, the programming language used for implementing smart contracts across various blockchain platforms.

For detailed insights into the project, including its design, implementation, and website functionalities, as well as screenshots and user workflows, please refer to the attached report in this repository: **Design_Document.pdf**

The setup instructions are provided below. You may choose to utilise Docker-compose for convenience or opt for manual setup if preferred.

## Architecture

- **Frontend**: React + Tailwind CSS
- **Backend**: Python FastAPI
- **Smart Contract Analysis**: Slither API
- **Database**: MySQL

## Project folder structure

```bash
FULLSTACK-GUI-FOR-SLITHER/
├── backend/                    # Backend application folder
│   ├── slither.wiki/           # Contains documentation cloned from slither.wiki
│   │   └── Detector-Documentation.md  # Documentation file about Slither detectors
│   ├── uploads/                # Folder for storing uploaded contract files by user
│   ├── __init__.py
│   ├── crud.py                 # Manages CRUD (Create, Read, Update, Delete) operations for database interactions
│   ├── database.py             # Handles database connection and session management
│   ├── main.py                 # Main entry point for the backend application
│   ├── models.py               # Defines database models using SQLAlchemy's declarative base
│   ├── services.py             # Provides utility functions such as Slither-related commands for application logic
│   ├── requirements.txt        # Lists required Python packages to install for the backend
│   ├── Dockerfile              # Dockerfile for building the backend image
│   └── .dockerignore           # Specifies files and directories to be ignored during Docker build
├── frontend/                   # Frontend application folder
│   ├── node_modules/           # Contains dependencies for the frontend
│   ├── public/                 # public folder
│   ├── src/                    # Source code folder for the frontend
│   │   ├── assets/             # Stores static images used by the frontend
│   │   ├── components/         # Contains reusable React components
│   │   ├── pages/              # React components representing different pages of the application
│   │   ├── api.js              # Handles API calls and interactions with the backend from the frontend
│   │   ├── App.js              # The main React component for the application
│   │   ├── constant.js         # Defines constants used throughout the frontend application
│   │   ├── index.css           # CSS file for styling
│   │   ├── index.js            # Entry point for frontend app
│   │   ├── package-lock.json   # Generated by React
│   │   ├── package.json        # Specify the project's dependencies
│   │   └── tailwind.config.js   # Configuration file for Tailwind CSS
│   ├── Dockerfile              # Dockerfile for building the frontend image
│   └── .dockerignore           # Specifies files and directories to be ignored during Docker build
├── docker-compose.yml          # Docker Compose file for defining multi-container Docker applications
└── README.md                   # Project README file providing an overview of the project
```

## Setup/Deployment

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### OPTION 1: Using Docker Compose (RECOMMENDED)

To run the Smart Contract Audit System using Docker Compose, follow these steps:

1. Open a terminal and navigate to the project root directory.

2. Run the following command to build and start the containers:

    ```bash
    docker-compose up
    ```

3. Access the frontend at [http://localhost:3000](http://localhost:3000). Upon accessing this URL, you'll be directed to the home page of the Smart Contract Audit System.

4. Use the upload form on the frontend to submit a Solidity smart contract file (`.sol`) for auditing. Simply drag and drop the file onto the designated area to initiate the auditing process.

5. The backend will run static analysis via Slither and save the results to the database.

6. Audit reports for each submission can be viewed on the **Report History** page. To access this page, locate and click on the "Report History" link in the navigation bar.

7. To stop the containers, use `Ctrl + C` in the terminal where Docker Compose is running, and then run:

    ```bash
    docker-compose down
    ```

#### Running Slither inside Docker container (Optional)

If you need to run Slither commands inside the backend container, you can use the following steps:

1. Access the backend container:

    ```bash
    docker-compose exec backend bash
    ```

2. Once inside the container, you can run Slither commands. For example:

    ```bash
    solc-select install 0.8.4
    solc-select use 0.8.4 
    slither contract.sol --checklist > result.md
    ```

### OPTION 2: No Docker

#### Prerequisites

- Node.js
- Python 3

#### Frontend

```bash
cd frontend
npm install
npm start
```

#### Backend

```bash
cd backend
pip3 install virtualenv
virtualenv venv
venv\Scripts\activate
pip3 install -r requirements.txt
uvicorn main:app --reload
```

On wins: ```Set-ExecutionPolicy Unrestricted -Scope Process``` (only if have error: cannot run scripts due to restricted permissions)

**Note:**

- MacOS use: ```source venv/bin/activate```
- Windows use: ```venv\Scripts\activate```

### Usage

The frontend will be available at [http://localhost:3000](http://localhost:3000)

There are 3 .sol files within **test_sol_files** for testing purposes.

Use the upload form to submit a solidity smart contract file (.sol) for auditing.

The backend will run static analysis via Slither and save results to the database.

Audit reports for each submission can be viewed on the **Report History** page.

### Documentation

- Backend API documentation is available at [http://localhost:8000/docs](http://localhost:8000/docs)
