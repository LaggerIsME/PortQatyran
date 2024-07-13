#!/bin/bash

# Check notification mode
if [ "$NOTIFICATION_MODE" = "aggresive" ]; then
  /bin/bash /app/scripts/aggresive_mode.sh
else
  /bin/bash /app/scripts/pacific_mode.sh
fi
