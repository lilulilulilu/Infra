# 一、创建master节点
# 1.对于Elasticsearch，这个设置很重要，因为Elasticsearch（特别是它的底层搜索引擎Lucene）会创建大量的虚拟内存区域。如果 vm.max_map_count 的值太低，Elasticsearch可能无法正常运行或表现出性能问题。Elasticsearch官方文档通常建议将这个值设置为 262144，以确保Elasticsearch可以正常运行。
sysctl -w vm.max_map_count=262144

# 2.启动master节点
docker run -e ES_JAVA_OPTS="-Xms32g -Xmx32g" --name es01 -p 9200:9200 -p 9300:9300 --net elastic -itd -m 34GB docker.elastic.co/elasticsearch/elasticsearch:8.11.0

# 3.查看日志
docker logs es01

# 4.安装ik
docker exec -it es01 /bin/bash
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v8.11.0/elasticsearch-analysis-ik-8.11.0.zip
docker restart es01

# 5.查看plugin
./bin/elasticsearch-plugin list


# 二、安装kibana
docker pull docker.elastic.co/kibana/kibana:8.11.0
docker run --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.11.0
#启动kibana后用上面创建的master打印出的日志里的账号密码登录kibana

# 三、逐个添加data节点
# 1.在主节点上生成令牌
docker exec -it es01 /bin/bash
bin/elasticsearch-create-enrollment-token -s node

# 2.用Dockerfile打包生成一个安装了ik的elasticsearch镜像
docker build -f Dockerfile --tag=elastic-ik:v1 .

# 3.添加data节点es02
docker run -e ES_JAVA_OPTS="-Xms32g -Xmx32g" --name es02 --net elastic -p 9202:9200 -p 9302:9300 -e "ENROLLMENT_TOKEN=eyJ2ZXIiOiI4LjExLjAiLCJhZHIiOlsiMTcyLjE5LjAuMjo5MjAwIl0sImZnciI6IjI2YTk3ZTc0OTQ5NGRkZGY0OWY5YjM4MjliNWYxMjBjZmFjYTllODI4ZmQ4ZmUzODliMDJiMjVjM2QzZTlkMmYiLCJrZXkiOiJURTBsaG93QjVyU0lKY3h1bjktNjp2X2ZjUWpvOVNKR1UzcjZQdi1Ta3NnIn0=" -itd elastic-ik:v1 

# 4.添加data节点es03
docker run -e ES_JAVA_OPTS="-Xms32g -Xmx32g" --name es03 --net elastic -p 9203:9200 -p 9303:9300 -e "ENROLLMENT_TOKEN=eyJ2ZXIiOiI4LjExLjAiLCJhZHIiOlsiMTcyLjE5LjAuMjo5MjAwIl0sImZnciI6IjI2YTk3ZTc0OTQ5NGRkZGY0OWY5YjM4MjliNWYxMjBjZmFjYTllODI4ZmQ4ZmUzODliMDJiMjVjM2QzZTlkMmYiLCJrZXkiOiJURTBsaG93QjVyU0lKY3h1bjktNjp2X2ZjUWpvOVNKR1UzcjZQdi1Ta3NnIn0=" -itd elastic-ik:v1

# 四、在kibana的Dev tool console查看节点信息
GET /_cat/nodes?v&pretty
# ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role   master name
# 172.19.0.5           29          92   0    0.22    0.77     0.90 cdfhilmrstw -      ae3a83e43221
# 172.19.0.2           58          66   0    0.22    0.77     0.90 cdfhilmrstw *      155f952e0ed4
# 172.19.0.4           17          92   0    0.22    0.77     0.90 cdfhilmrstw -      ec7e7cb0a0af
