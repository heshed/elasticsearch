################################################################################
# Pull baseimage and start
FROM phusion/baseimage:0.9.15

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

################################################################################
# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

################################################################################
# Install Python.
# apt-get install python-software-properties
#RUN apt-get install -y python python2.7 python-dev python-distribute python-pip

# Clean apt.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

################################################################################
# Packages variables
ENV ES_PKG_NAME elasticsearch-1.4.2
ENV LOGSTASH_PKG_NAME logstash-1.4.2
#ENV KIBANA3_PKG_NAME kibana-3.1.2
ENV KIBANA4_PKG_NAME kibana-4.0.0-beta3

ENV ES_DOWNLOAD_URL https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz
ENV LOGSTASH_DOWNLOAD_URL https://download.elasticsearch.org/logstash/logstash/$LOGSTASH_PKG_NAME.tar.gz
#ENV KIBANA3_DOWNLOAD_URL https://download.elasticsearch.org/kibana/kibana/$KIBANA3_PKG_NAME.tar.gz
ENV KIBANA4_DOWNLOAD_URL https://download.elasticsearch.org/kibana/kibana/$KIBANA4_PKG_NAME.tar.gz

################################################################################
# Install ELK
WORKDIR /
RUN wget --no-check-certificate -O- $ES_DOWNLOAD_URL && tar xvfz - && mv /$ES_PKG_NAME /elasticsearch
RUN wget --no-check-certificate -O- $LOGSTASH_DOWNLOAD_URL && tar xvfz - && mv /$LOGSTASH_PKG_NAME /logstash
#RUN wget --no-check-certificate -O- $KIBANA3_DOWNLOAD_URL && tar xvfz - && mv /$KIBANA3_PKG_NAME /kibana3
RUN wget --no-check-certificate -O- $KIBANA4_DOWNLOAD_URL && tar xvfz - && mv /$KIBANA4_PKG_NAME /kibana4

# Install es plugins
RUN /elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ
RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head
RUN /elasticsearch/bin/plugin -install lukas-vlcek/bigdesk
RUN /elasticsearch/bin/plugin -install karmi/elasticsearch-paramedicl
#RUN /logstash/bin/plugin install contrib
#RUN pip install elasticsearch-curator

################################################################################
# ELK Settings
ENV CONFIG_DIR config
ADD $CONFIG_DIR/elasticsearch.yml /elasticsearch/config/elasticsearch.yml
ADD $CONFIG_DIR/config.js /kibana/config.js

################################################################################
# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]
CMD ["/logstash/bin/logstash"]
CMD ["/kibana4/bin/kibana"]

CMD ["/sbin/my_init"]

# Define working directory.
WORKDIR /data

# Expose ports.
#   - 9200: ES HTTP
#   - 9300: ES transport
#   - 9292: Kibana
EXPOSE 9292
EXPOSE 9200
EXPOSE 9300
EXPOSE 80

################################################################################
# TODO:Usage
# run es
# docker run -it --rm -p 9200:9200 -p 9300:9300 --name es heshed/elasticsearch /elasticsearch/bin/elasticsearch

# docker run -it --rm -e LOGSTASH_CONFIG_URL=<your_logstash_config_url> -p 9292:9292 -p 9200:9200 --link es:es heshed/elasticsearch /logstash/bin/logstash

# docker run -it --rm -p 80:80 heshed/elasticsearch /kibana4/bin/kinana
# docker run -it --rm -p 5000:5000 -p 5000:5000/udp --link es:elasticsearch heshed/elasticsearch -f /etc/logstash.conf.sample
