FROM phusion/baseimage

MAINTAINER George Vanburgh

#############################
# Install required software #
#############################

# Install dependencies
RUN   apt-add-repository ppa:chris-lea/node.js        && \
      apt-get -y update                               && \
      apt-get install -y --no-install-recommends         \
        adduser                                          \
        git                                              \
        libfontconfig                                    \
        nodejs                                           \
        python-software-properties                    && \
      apt-get autoclean && apt-get clean              && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# InfluxDB
RUN   curl https://s3.amazonaws.com/influxdb/influxdb_0.10.1-1_amd64.deb > /tmp/influxdb_0.10.1-1_amd64.deb &&\
      dpkg -i /tmp/influxdb_0.10.1-1_amd64.deb        && \
      rm /tmp/influxdb_0.10.1-1_amd64.deb

# StatsD
RUN   cd /opt                                         && \
      git clone https://github.com/etsy/statsd.git    && \
      cd statsd                                       && \
      npm install statsd-influxdb-backend

# Grafana
RUN   curl https://grafanarel.s3.amazonaws.com/builds/grafana_2.6.0_amd64.deb > /tmp/grafana_2.6.0_amd64.deb && \
      dpkg -i /tmp/grafana_2.6.0_amd64.deb            && \
      rm /tmp/grafana_2.6.0_amd64.deb

###################
# Start container #
###################

ADD   statsd/config.js /opt/statsd/config.js

ADD   docker-entrypoint.sh /

EXPOSE 3000 8086

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["*"]
