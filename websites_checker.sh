#!/bin/bash

sites_to_check=(
  "https://www.google.com"
  "https://www.facebook.com"
  "https://www.twitter.com"
  "https://www.youtube.con"  # test for unknown domain
)

log_file="websites_statuses.log"

for site in "${sites_to_check[@]}"; do
  http_status=$(curl -sL -o /dev/null -w "%{http_code}" "${site}")
  curl_exit_code=$?

  if [[ $http_status == "200" ]]; then
    echo "$(date) - ${site} is UP" >> $log_file
  elif [[ $curl_exit_code != 0 ]]; then
    echo "$(date) - ${site} check failed due to curl error (code $curl_exit_code)" >> $log_file
  else
    echo "$(date) - ${site} is DOWN (HTTP Status: $http_status)" >> $log_file
  fi
done

if [[ -f "$log_file" && -s "$log_file" ]]; then
    echo "Websites checks results have been written to $(realpath $log_file)"
else
    echo "File does not exist or is empty."
fi
