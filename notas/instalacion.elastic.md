ElasticSearch funciona en cluster:
Tendremos distintos nodos:
- Datos                 Al menos 2
- Ingesta               No hay minimo
- Master                3
- Coordinadores         No hay minimo

Tienen configuraciones distintas

Deployment
StatefulSet  <<<<

------------
Kibana
    Deployment <<<<<
    StatfulSet

-----


version: '3.0'
services:

# 2 Maestros
# 4 datas (1 votacion)
# 2 ingestas
# 2 coordinadores
# -------
# 10 Nodos
  
  # maestro1
  # maestro2
  # ingesta1
  # ingesta2
  # coordinador1
  # coordinador2
  # data1
  # data2
  # data3
  # data4
  

# 3 redes 
# Securizar HTTPS

  maestro1:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: maestro1
    ports:
      - 8080:9200
    volumes:
      - /home/ubuntu/environment/datos/nodo1:/usr/share/elasticsearch/data
    environment:
      - node.name=maestro1
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro2
      - cluster.initial_master_nodes=maestro1,maestro2 # Limitar a TODOS los posibles maestro
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=true
      - node.voting_only=false 
      - node.data=false 
      - node.ingest=false 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
          
          

  maestro2:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: maestro2
    volumes:
      - /home/ubuntu/environment/datos/nodo2:/usr/share/elasticsearch/data
    environment:
      - node.name=maestro2
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1
      - cluster.initial_master_nodes=maestro1,maestro2 # Limitar a TODOS los posibles maestro
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=true
      - node.voting_only=false 
      - node.data=false 
      - node.ingest=false 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
          
          
  data1:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: data1
    volumes:
      - /home/ubuntu/environment/datos/nodo3:/usr/share/elasticsearch/data
    environment:
      - node.name=data1
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1,maestro2
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=true
      - node.voting_only=true 
      - node.data=true 
      - node.ingest=false 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 

  data2:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: data2
    volumes:
      - /home/ubuntu/environment/datos/nodo4:/usr/share/elasticsearch/data
    environment:
      - node.name=data2
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1,maestro2
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=false
      - node.voting_only=false 
      - node.data=true 
      - node.ingest=false 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
          
  data3:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: data3
    volumes:
      - /home/ubuntu/environment/datos/nodo5:/usr/share/elasticsearch/data
    environment:
      - node.name=data3
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1,maestro2
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=false
      - node.voting_only=false 
      - node.data=true 
      - node.ingest=false 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
      - node.attr.color=azul
          
  data4:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: data4
    volumes:
      - /home/ubuntu/environment/datos/nodo6:/usr/share/elasticsearch/data
    environment:
      - node.name=data4
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1,maestro2
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=false
      - node.voting_only=false 
      - node.data=true 
      - node.ingest=false 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
      - node.attr.color=azul,verde

          
  ingesta1:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: ingesta1
    volumes:
      - /home/ubuntu/environment/datos/nodo7:/usr/share/elasticsearch/data
    environment:
      - node.name=ingesta1
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1,maestro2
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=false
      - node.voting_only=false 
      - node.data=false 
      - node.ingest=true 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
          
          
  ingesta2:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: ingesta2
    volumes:
      - /home/ubuntu/environment/datos/nodo8:/usr/share/elasticsearch/data
    environment:
      - node.name=ingesta2
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1,maestro2
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=false
      - node.voting_only=false 
      - node.data=false 
      - node.ingest=true 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
          
          
  coordinador1:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: coordinador1
    volumes:
      - /home/ubuntu/environment/datos/nodo9:/usr/share/elasticsearch/data
    environment:
      - node.name=coordinador1
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1,maestro2
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=false
      - node.voting_only=false 
      - node.data=false 
      - node.ingest=false 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
          
          
  coordinador2:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.7.0
    container_name: coordinador2
    volumes:
      - /home/ubuntu/environment/datos/nodo10:/usr/share/elasticsearch/data
    environment:
      - node.name=coordinador2
      - cluster.name=MiCluster
      - discovery.seed_hosts=maestro1,maestro2
      - "ES_JAVA_OPTS=-Xms220m -Xmx220m"
#      - bootstrap.memory_lock=true # Desactivar el swapping para la memoria de elastic
      - node.master=false
      - node.voting_only=false 
      - node.data=false 
      - node.ingest=false 
      - node.remote_cluster_client=false  # cluster.remote.connect: false 
          


          
  cerebro:
    image: lmenezes/cerebro:0.8.5
    container_name: cerebro
    ports:
      - 8081:9000
    volumes:
      - ./application.conf:/opt/cerebro/conf/application.conf

  kibana:
    image: docker.elastic.co/kibana/kibana:7.7.0
    container_name: kibana
    ports:
      - 8082:5601
    environment:
      ELASTICSEARCH_HOSTS: "http://coordinador1:9200"
      SERVER_NAME: "kibana"
      SERVER_HOST: "kibana"
      
----
Servicios:
    servicio-comunicacion-nodos   9300
    kibana                        5601
    servicio ingesta1             9200
    servicio datos                9200 (coordinadores)
    servicio master <<<<<         9200-9300
----
Deployment
Statefulset a cascoporro
Configmap
Secret
