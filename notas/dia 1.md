Chart es concepto básico en HELM

# Que es un chart?
Es un conjunto de YAMLs y otras cosas... que nos permite crear objetos en Kubernetes.
Que lleva una estructura determinada.

# Que cosas necesitamos crear en Kubernetes/Openshift para poner en marcha una app?

Pod <<<< Deployments        Despliega un número de replicas de un pod. El nombre de esas replicas es "aleatorio"
         StatfulSets        Despliega un número de replicas de un pod. El nombre de esas replicas es "secuencial", que se mantiene.
                            Los pods generados desde un statfulset tienen personalidad propia.
         DaemonSets         Depliega tantas replicas de un podo como nodos hay en el cluster.

Servicios  <<< Permiten la comunicación con los puertos de los pods.
               Si no tengo un servicio asociado a un pod, puedo comunicarme con el puerto del pod? SI PUEDO, a través de la IP del POD.
               Problemas: 
                1- La IP es a priori desconocida y además sujeta a cambios
                2- Que pasa si hay varias replicas del POD. Necesito un balanceador de carga
               Los servicios ofrecen:
                1- Los servicios tiene un nombre DNS (coreDNS)
                2- Ofrecen balenado de carga

Configuraciones:
    ConfigMaps
    Secrets

Namespace

Ingress     Dar acceso a un servicio desde el exterior del cluster.
            Es la única manera de conseguir eso?
                Alternativamente podriamos hacer un servicio de tipo NodePort o LoadBalancer

En Openshift normalmente trabajamos con Route en lugar de Ingress

Persistencia de la información:
                            PersistentVolume: Es responsabilidad del administrador del cluster de kubernetes. Esto lo puede hacer:
                                    1 - Manualmente
                                    2 - A través de un provisionador

PersistentVolumeClaim: Peticion de volumen persistente

OPCIONALMENTE:
- ServiceAccount            Una cuenta con permisos para que el pod acceda a información del cluster
        - Role o ClusterRole    Definir permisos
        - Asociación entre el serviceAccount y los roles

HELM Es un gestor de paquetes para Kubernetes

----------------------

Que pasa con los pvc que se crean.... y la diferencia de si el pvc ha sido creado para un statefulset o un deployment

Deployment vs StatefulSet
    Deployment tenia nombre random de pods
    Mientra que el statefulset genera numbre secuenciales
Y eso que implica?
Esto tiene una implicación ENORME a la hora de gestionar los VOLUMENES.
----------------------
Wordpress - CRM
    Base de datos
    Servidor WEB: php - Apache, nginx
    
Quiero montar mi web con Wordpress:
    - Crear unos usuarios que administren el sitio      >>>>    BBDD
    - Crear unas páginas web                            >>>>    BBDD
    - Voy a tener que subir unas imágenes               >>>>    Carpeta gestionada por el servidor WEB
    
Cuantos tipos de contenedores voy a tener?
    - NGINX - Apache .... Wordpress
    - BBDD           .... MariaDB

Cuantos tipos de PODs voy a tener?
    - Deployment        - Apache - Wordpress
    - Statefulset       - MariaDB

Os habeis ido a montar Deployments... Statefulsets.... Por que no monto un pod? directamente? Podría? tiene sentido?
    Monto un POD para MARIADB
    Monto otro POD para Apache-Wordpress

Escalabilidad - replicas 
    
Quiero un único POD con MariaDB y Apache dentro, juntitos. NO, desde el momento en que APACHE y MARIADB no tienen porqué escalar de la misma forma.

Voy a escalar y en un momento dado quiero:
- Quiero 2 mariasDB 
- Quiero 3 wordpress

A que datos tienen que acceder cada uno de los pods
Todos los wordpress deben acceder a la misma información? a los mismos archivos?
    SI >>> Todos los PODS deben trabajar contra el mismo VOLUMEN                   <<<<<< DEPLOYMENT
Todos los mariadb deben acceder a la misma información? a los mismos archivos?
    NO 
    
Cómo escala MARIADB? Si monto un escalado con MariaDB, cada base de datos que genero en un cluster (POD) tiene solo una parte de los datos.
Por lo tanto, cada BBDD necesita disponer de su propio VOLUMEN                     <<<<<< STATEFULSET

MariaDB
ElasticSearch
Kafka


