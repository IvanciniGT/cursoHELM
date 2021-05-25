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