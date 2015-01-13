docker run -d -p 3333:3333 --name=logstash --link=es:es heshed/elasticsearch /logstash/bin/logstash -f /config/logstash.conf
