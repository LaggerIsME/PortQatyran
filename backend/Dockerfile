# Choose Docker Image
FROM python:3.12-slim-bookworm
LABEL authors="LaggerIsME <https://github.com/LaggerIsME>"

# Create directory for project
WORKDIR /app
# Copy dependencies
COPY ./requirements.txt /app/requirements.txt
# Update pip tools
RUN pip install --no-cache-dir --upgrade --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org setuptools
# Install dependencies
RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r /app/requirements.txt
# Copy other files
COPY . .
