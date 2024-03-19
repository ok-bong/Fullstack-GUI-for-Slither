# Use an official Python runtime as a base image
FROM python:3.8-slim

# Set the working directory
WORKDIR /app/backend

# Copy the requirements file to the working directory
COPY requirements.txt .

# Install FastAPI dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project to the working directory
COPY . .

# Expose port 8000 (adjust as needed)
EXPOSE 8000

# Command to run the FastAPI app with uvicorn and use the .env file
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload", "--env-file", ".env"]
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]