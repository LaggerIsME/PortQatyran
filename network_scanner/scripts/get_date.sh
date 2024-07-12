#!/bin/bash

date_without_tz=$(date "+%d %B %Y %T %:z")
date_with_tz="${date_without_tz} $TZ"

echo "$date_with_tz" >> /var/log/portqatyran.log
