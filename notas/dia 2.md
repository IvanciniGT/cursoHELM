# Tipos de Servicios

- ClusterIP         Servicio interno al cluster....O cuando voy a exportarlo mediante un ingress
- NodePort          Es como ClusterIP pero además: Mapea en TODOS los nodos del cluster un puerto al servicio interno.
                        Limitación: Puertos desde el 30000-32###
- LoadBalancer      De entrada es igual a un clusterIP, pero además:
                        - Abre un puerto en una IP de la red pública.
                        - Ese puerto redirige al servicio interno.
                        - De donde se saca esa IP? Me la tiene que dar un proveedor externo.
                            - En los clouds, esto es de serie
                        - En un cluster onPremisses, solemos utilizar MetalLB



-----

192.168.1.1   ROUTER - NAT
   ^^^^
192.168.2.1   ROUTER - NAT 

192.168.2.100       |   PODS        172.17.0.1, 2, 3, 4
192.168.2.101       |   SERVICIOS   172.17.0.100,101,102,103
192.168.2.102       |
192.168.2.103       |
192.168.2.104       |

192.168.2.200 Nodo 3 -192.168.2.102

METALLB (192.168.2.200-210)


-------
Wordpress > Deployment    > Todas las replicas tienen el mismo volumen asignado
    Persistencia:
MySQL     > StatefulSet   > Cada replica tiene su propio volumen, que se obtiene desde un claim generado por una plantilla
    Persistencia
    
Que va a hacer HELM para gestionar todo esto?
    Deployment, que hace?
        Crea un persistentVolumeClaim
    StatefulSet?
        Crea un Statefulset, que dentro lleva el template de los Claims
        
Que pasa si desinstalo un chart?
    - Se borran los claims?
        - Que pasa con el claim del deployment?  ES BORRADO 
        - Que pasa con el claim del statefulset? NO ES BORRADO

Todos los pvc (claims) generados por Kubernetes para el statefulset, que nombres reciben? Basado en el nombre del pod.
    Si más adelante reinstalo, que pasa? Se reusan los mismos pvcs <<< Se usan los mismos volumenes
    
Para el caso del deployment. Que pasa si hago un uninstall y despues reinstalo?
    Se recrean los pvcs, e independientemente del reclaim policy, que volumenes se me asignan?
        Se me asigna un volumen nuevo, limpio de datos.
        
        
---------------------

Wordpress
    ----> Volumen  ----> Contenido de que? Imagenes, Plugins, Tema

Que pasaría si Wordpress fuera un statefulset?
Y yo tuviera 3 replicas?


Cada replica tendría el que? Su propio volumen 

---------------------
Que tipo de servicio monto?
    Esto no depende del numero de replicas
    Depende de como me conecto con el servicio


Ingress < ClusterIP
No Ingress > NodePort
                
             LoadBalancer
    
NodePort 30004

Cluster
    Nodo 1
        Exponer 30004  > Pasa la llamada a la IP del servicio
        Reglas NetFilter <<<< Quien las establece? KUBE-PROXY
            Cuando llamen a esta IP (IP DEL SERVICIO) desde esta maquina
                reenvialo a una de estas IPs:
                    - IP Pod A
                    - IP Pod B
        Pod Kibana A
    Nodo 2
        Reglas NetFilter
            Cuando llamen a esta IP (IP DEL SERVICIO) desde esta maquina
                reenvialo a una de estas IPs:
                    - IP Pod A
                    - IP Pod B
        Exponer 30004  > Pasa la llamada a la IP del servicio
    Nodo 3
        Reglas NetFilter
            Cuando llamen a esta IP (IP DEL SERVICIO) desde esta maquina
                reenvialo a una de estas IPs:
                    - IP Pod A
                    - IP Pod B
        Exponer 30004  > Pasa la llamada a la IP del servicio
        Pod Kibana B

Service.... que es un service al final en Kubernetes?

Con un servicio NodePort... donde ataca el cliente final?
    A que IP?
        La IP publica de cualquiera de los nodos del cluster
        Le doy una lista... y que elija?
        Podria darle solo una IP? que problema tengo en este escenario?
            Si el nodo cae... estoy jodido....
        Necesito un balanceador de carga... externo... que tenga una IP publica
            y redirija a una de las IP de los host, a cualquiera:
                Servicio de tipo LOAD_BALANCER
    El puerto: 30004
    

----


Nodo 1
    Pod1
    Pod2
Nodo 2
    Pod3
    
Si estando dentro de una bash en Pod 1 escribo:
    ping "Pod2"  NO FUNCIONA
    ping "Pod3"  NO FUNCIONA
Necesito un ping a un servicio  >>>> pod
                        VVVV
                        Nombre de red
                        

Statefulset
    POD: Maestro1   >>> Oye... mira a ver si hay alguien mas por ahi? discovery.seed_hosts
    POD: Maestro2   >>> Oye... mira a ver si hay alguien mas por ahi? discovery.seed_hosts
    POD: Maestro3   >>> Oye... mira a ver si hay alguien mas por ahi? discovery.seed_hosts

Servicio que voy a crear para el statefulset
    Podria pasar que el servicio del statefulset redirija al maestro1? SI
    Podria pasar que el servicio del statefulset redirija al maestro2? SI
    Podria pasar que el servicio del statefulset redirija al maestro3? SI

Cuantos servicios necesito? 1 por maestro.



ping elastic-maestro-0.elastic-maestro
    ---> El pod del maestro 0
    
ping elastic-maestro
    ----> Alguno de los pods
