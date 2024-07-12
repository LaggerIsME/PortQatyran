echo "[DATE_OF_SCRIPT_START]"

# Add env variables for cron
env >> /etc/environment

echo "Added env variables" >> /var/log/cron.log