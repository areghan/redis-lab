# Use the official Python runtime
FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Copy only the dependency list first
COPY requirements.txt .

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Tell Docker which port the application listens on
EXPOSE 8000

# Start the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]