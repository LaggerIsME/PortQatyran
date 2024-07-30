# Choose Docker Image
FROM debian:bookworm-slim
LABEL authors="LaggerIsME <https://github.com/LaggerIsME>"

# Create directory for project
WORKDIR /app

# Copy files from host to container
COPY ./auto.cronjob /app/auto.cronjob
COPY ./scripts/ /app/scripts/
COPY ./.rustscan.toml /app/


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

# Download rustscan.deb from official repository
RUN curl -O -k -L "https://github.com/RustScan/RustScan/releases/download/2.3.0/rustscan_2.3.0_amd64.deb"

# Add aliases
RUN cat /app/scripts/ascii_logo.sh > /bin/qatyranfetch
RUN chmod +x /bin/qatyranfetch
RUN cat /app/scripts/main.sh > /bin/portqatyran
RUN chmod +x /bin/portqatyran
# Install rustscan
RUN dpkg -i rustscan_2.3.0_amd64.deb
# Run cron in background and does not allow container to stop
#CMD cron && tail -f /app/output.txt /var/log/cron.err
