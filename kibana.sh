docker run -d -p 80:80 --name=kibana heshed/elasticsearch /kibana4/bin/kibana -c /config/kibana.yml -e http://127.0.0.1:9200 -p 80
