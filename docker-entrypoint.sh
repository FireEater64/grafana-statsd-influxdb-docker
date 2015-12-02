#!/bin/bash

set -e

if [[ "$1" = '*' ]]; then
  # Fire up all the things
  service influxdb start &
  service grafana-server start &
  /opt/statsd/bin/statsd /opt/statsd/config.js &
  wait
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
