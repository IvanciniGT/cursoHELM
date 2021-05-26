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