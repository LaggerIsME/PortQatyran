# Add env variables for cron
env >> /etc/environment

/bin/bash /app/scripts/get_date.sh

echo "Added env variables" >> /var/log/portqatyran.log