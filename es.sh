mkdir -p data
docker run -d -p 9200:9200 -p 9300:9300 --name=es -v `pwd`/data:/data heshed/elasticsearch /elasticsearch/bin/elasticsearch -Des.config=/config/elasticsearch.yml
