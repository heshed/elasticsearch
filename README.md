## Forked from http://dockerfile.github.io/#/elasticsearch


## ElasticSearch(1.4.2) Logstash(1.4.2) Kibana(4.0.0.beta3) Dockerfile


This repository contains **Dockerfile** of [ElasticSearch](http://www.elasticsearch.org/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/heshed/elasticsearch/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).


### Base Docker Image

* [phusion/baseimage](https://registry.hub.docker.com/u/phusion/baseimage/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/heshed/elasticsearch/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull heshed/elasticsearch`

   (alternatively, you can build an image from Dockerfile: `docker build -t="heshed/elasticsearch" github.com/heshed/elasticsearch`)


### Usage

    docker run -d heshed/elasticsearch /elasticsearch/bin/elasticsearch

    docker run -d heshed/elasticsearch /kibana4/bin/kibana

    docker run -d heshed/elasticsearch /logstash/bin/logstash

#### Attach persistent/shared directories

  1. Create a mountable data directory `<data-dir>` on the host.

  2. Create ElasticSearch config file at `<data-dir>/elasticsearch.yml`.

    ```yml
    path:
      logs: /data/log
      data: /data/data
    ```

  3. Start a container by mounting data directory and specifying the custom configuration file:

    ```sh
    # elasticsearch
    docker run -d -p 9200:9200 -p 9300:9300 --name=es -v `pwd`/data:/data heshed/elasticsearch /elasticsearch/bin/elasticsearch -Des.config=config/elasticsearch.yml

    # kibana
    docker run -d -p 80:80 heshed/elasticsearch --name=kibana /kibana4/bin/kibana -c config/kibana.yml -e http://127.0.0.1:9200 -p 80

    # logstash
    docker run -d -p 3333 --name=logstash --link=es:es heshed/elasticsearch /logstash/bin/logstash -f config/logstash.conf
    ```

After few seconds, open `http://<host>:9200` to see the result.
