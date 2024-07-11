# Choose Docker Image
FROM debian:bookworm-slim
LABEL authors="LaggerIsME <https://github.com/LaggerIsME>"

# Create directory for project
WORKDIR /app

# Copy files from host to container
COPY ./auto.cronjob /app/auto.cronjob
COPY ./hosts.txt /app/hosts.txt

# Install tools:
# Curl for HTTP requests
# Cron for scheduling tasks
# Nmap for Rustscan
RUN apt-get update && apt-get install -y curl cron nmap

# Set Timezone
ENV TZ=Asia/Almaty
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add cronjob to cron
RUN chmod 0644 /app/auto.cronjob && crontab /app/auto.cronjob

# Create file for cron logs
RUN touch /var/log/cron.log

# Download rustscan.deb from official repository
RUN curl -O -k -L "https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan_2.3.0_amd64.deb"

# Install rustscan
RUN dpkg -i rustscan_2.3.0_amd64.deb

# Run cron in background and does not allow container to stop
CMD cron && tail -f /var/log/cron.log /var/log/cron.err
