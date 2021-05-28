ElasticSearch:
    3 maestros
    2 data
    0 o al menos 2 coordinadores
    0 o al menos 2 ingesta
    
Query >>>> ? Coordinador  >>>> Data
Ingesta >>>> ? Ingesta >>>> Data



elasticsearch:
    
    info_generica:
    
    master:
    
    data:
    
    ingest:
    
    coordinator:
    
    services:
        consulta:
            parametrizar: Puertos, nombre
            ¿Quien va a haber detrás? Chart
        ingesta:
            parametrizar: Puertos, nombre
            ¿Quien va a haber detrás? Chart


---
Kubernetes:
>>>     ClusterIP           Servicios Internos
        NodePort            = ClusterIP + exponen un puerto en todos los nodos > 30000
        LoadBalancer        = NodePort + exponen un puerto en una IP publica

NodePort y LoadBalancer solo aportan exposición del servicio
Hay otra forma de exponer un servicio?
    Ingress <<< ClusterIP
        TLS < Seguridad https
        
        
Si monto un servicio LoadBalancer o NodePort, quien sirve directamente la petición?
    ElasticSearch <<<< Puedo configurarlo para trabajar por HTTPS?
        Si.... lo voy a hacer de cara a mis usuarios finales?
            NO ... que pasa con el certificado? 
            
Como es un certificado que vaya a ser utilizado por usuarios finales?
    Tiene que estar firmado por una CA de confianza.
    
App que meta datos en Elastic?
App que busque datos en elastic?

         https (CA)        https(CAx)
USUARIO    >>>>     INGRESS      >>>>    ES (privado)
                     nginx
                     cert-manager
                     
USUARIO    >>>>>>>>>>>>>>>>>>>>>>>>>>    ES
                   https(CA)
                     


Maestro 1 >>> Maestro2:9300 y Maestro 3:9300

Maestro 2 >>> Maestro1 y Maestro 3

Maestro 3 >>> Maestro1 y Maestro 2

Data 3   >>>  Maestros (Balanceador - Service):9300 >>> Maestro 1:9300 o Maestro 2 o Maestro 3

Nodo 4   >>>  Maestros (Balanceador - Service) >>> Maestro 1 o Maestro 2:9300 o Maestro 3                   


Cuando Data 3 conozca al maetsro 1, que pasa?
    Le pilla su IP y... lo presenta al resto de hermanitos . En que puerto? 9300
    
    
----
           
helm install elastic-search-monitorizacion mies -n desarrollo -f values.yaml
    Que servicio quiero crear?
        Cómo quiero llamar al servicio que se cree para ingesta?
            "mies-elastic-ingesta"
            "mies-NAME_OVERRIDE"
            "FULL_NAME_OVERRIDE"