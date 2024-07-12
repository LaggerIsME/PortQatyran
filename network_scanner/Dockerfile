# Choose Docker Image
FROM debian:bookworm-slim
LABEL authors="LaggerIsME <https://github.com/LaggerIsME>"

# Create directory for project
WORKDIR /app

# Copy files from host to container
COPY ./auto.cronjob /app/auto.cronjob
COPY ./scripts/ /app/scripts/

# Make script executable
RUN chmod +x ./scripts/*

# Install tools:
# Curl for HTTP requests
# Cron for scheduling tasks
# Nmap for Rustscan
RUN apt-get update && apt-get install -y curl cron nmap

# Set Timezone
#ENV TZ=Asia/Almaty
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add cronjob to cron
RUN chmod 0644 /app/auto.cronjob && crontab /app/auto.cronjob

# Create file for portqatyran logs
RUN touch /app/output.txt
RUN touch /var/log/portqatyran.log
RUN touch /var/log/portqatyran.err

# Download rustscan.deb from official repository
RUN curl -O -k -L "https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan_2.3.0_amd64.deb"

# Install rustscan
RUN dpkg -i rustscan_2.3.0_amd64.deb
# Configure logs output
RUN ln -sf /dev/stdout /var/log/cron.log

# Run cron in background and does not allow container to stop
#CMD cron && tail -f /app/output.txt /var/log/cron.err
