helm >> Aplica un chart
    --> nombre deployment
        chart
        valores adicionales
        

Plantillas:
    .yaml
    _helpers    (DEFINE)
    
Helm al arrancar genera una variable en memoria RAM y 
    me la entrega para que pueda usarla dentro de las plantillas

Esa variable tiene estructura jerarquica. Esa variable se llama "$"
map[
    Capabilities:0x2a1d260 
    Chart:0xc0002af9e0 
    Files:map[
        .helmignore:[35 32 80 97 116 116 101 114 110 115 32 116 111 32 105 103 110 111 114 101 32 119 104 101 110 32 98 117 105 108 100 105 110 103 32 112 97 99 107 97 103 101 115 46 10 35 32 84 104 105 115 32 115 117 112 112 111 114 116 115 32 115 104 101 108 108 32 103 108 111 98 32 109 97 116 99 104 105 110 103 44 32 114 101 108 97 116 105 118 101 32 112 97 116 104 32 109 97 116 99 104 105 110 103 44 32 97 110 100 10 35 32 110 101 103 97 116 105 111 110 32 40 112 114 101 102 105 120 101 100 32 119 105 116 104 32 33 41 46 32 79 110 108 121 32 111 110 101 32 112 97 116 116 101 114 110 32 112 101 114 32 108 105 110 101 46 10 46 68 83 95 83 116 111 114 101 10 35 32 67 111 109 109 111 110 32 86 67 83 32 100 105 114 115 10 46 103 105 116 47 10 46 103 105 116 105 103 110 111 114 101 10 46 98 122 114 47 10 46 98 122 114 105 103 110 111 114 101 10 46 104 103 47 10 46 104 103 105 103 110 111 114 101 10 46 115 118 110 47 10 35 32 67 111 109 109 111 110 32 98 97 99 107 117 112 32 102 105 108 101 115 10 42 46 115 119 112 10 42 46 98 97 107 10 42 46 116 109 112 10 42 46 111 114 105 103 10 42 126 10 35 32 86 97 114 105 111 117 115 32 73 68 69 115 10 46 112 114 111 106 101 99 116 10 46 105 100 101 97 47 10 42 46 116 109 112 114 111 106 10 46 118 115 99 111 100 101 47 10]] 
    Release:map[
        IsInstall:true 
        IsUpgrade:false 
        Name:RELEASE-NAME 
        Namespace:default 
        Revision:1 
        Service:Helm] 
    Template:map[
        BasePath:mies/templates 
        Name:mies/templates/secrets.yaml] 
    Values:map[
        affinity:map[] 
        auth:map[
            existentSecretName:<nil> 
            passwordKey:password passwordValue:<nil> 
            userNameKey:user userNameValue:elastic] 
        autoscaling:map[enabled:false maxReplicas:100 minReplicas:1 targetCPUUtilizationPercentage:80] elasticsearch:map[clusterName:mi-cluster coordinator:map[nodeProperties:map[ES_JAVA_OPTS:-Xms220m -Xmx220m] persistence:map[enable:true storage:1Gi storageClass:<nil>] replicaCount:0] data:map[nodeProperties:map[ES_JAVA_OPTS:-Xms220m -Xmx220m] persistence:map[enable:true storage:1Gi storageClass:<nil>] replicaCount:2] image:map[pullPolicy:IfNotPresent repository:docker.elastic.co/elasticsearch/elasticsearch tag:7.7.0] ingest:map[nodeProperties:map[ES_JAVA_OPTS:-Xms220m -Xmx220m] persistence:map[enable:true storage:1Gi storageClass:<nil>] replicaCount:0] master:map[extraLabels:<nil> nodeProperties:map[ES_JAVA_OPTS:-Xms220m -Xmx220m] persistence:map[enable:true storage:1Gi storageClass:<nil>] replicaCount:3 service:map[fullnameOverride:<nil> nameOverride:<nil>]] nodeProperties:map[ES_JAVA_OPTS:-Xms1024m -Xmx1024m] ports:map[external:9200 internal:9300] services:map[ingest:map[fullnameOverride: nameOverride: port:9200 type:ClusterIP] query:map[fullnameOverride: nameOverride: port:9200 type:ClusterIP]]] fullnameOverride: image:map[pullPolicy:IfNotPresent repository:nginx tag:] imagePullSecrets:[] ingress:map[annotations:map[] enabled:false hosts:[map[host:chart-example.local paths:[map[backend:map[serviceName:chart-example.local servicePort:80] path:/]]]] tls:[]] kibana:map[extraLabels:map[mode:Ivan mode2:Ivancito] image:map[pullPolicy:IfNotPresent repository:docker.elastic.co/kibana/kibana tag:7.8.0] replicaCount:1 service:map[fullnameOverride:<nil> nameOverride:<nil> port:5601 targetPort:5601 type:ClusterIP]] nameOverride: nodeSelector:map[] podAnnotations:map[] podSecurityContext:map[] replicaCount:1 resources:map[] securityContext:map[] service:map[port:80 type:ClusterIP] serviceAccount:map[annotations:map[] create:true name:] tolerations:[]]]
        
    $.Release.Name
    $.Values  <<<<<<<< 
        Del fichero values.yaml que se encuentra en el chart
              ^^^
        Del fichero de values que yo pase cuando ejecuto 
            helm install | helm template    -f FICHERO_DE_VALUES
              ^^^
        Los que pasamos vía --set
    
    Cuando trabajamos en un template de HELM,
    Nos encontramos SIEMPRE en un CONTEXTO
    
    Que es un contexto?
     $ >>> Equivalente en un FileSystem de un ordenador a la /
     Un contexto es un valor en el que yo me encuentro posicionado en un momento dado
        En un filesystem de un ordenador correcponderia con $PWD       ---   .
        
        
    Como cambiado de diretorio en linux :   cd NOMBRE
    Como cambio de contexto en HELM:        Varias formas:
                                                with .Resources
                                                with $.Resources
                                                
                                                range genera un contexto
                                                    en el que solo tengo acceso a la clave y valor actual que estoy procesando
                                                
                                                include "TEMPLATE" NUEVO_CONTEXTO
                                                
Cuando arrancamos HELM, el contexto en el que me ubica es: $                                            


Si quiero iterar sobre una lista:

{{ range LISTA }}
    # Como me refiero a cada elemento de la lista? 
    {{ . }}
{{ end }}


Si quiero iterar sobre un diccionario:

{{ range $clave, $valor := DICCCIONARIO }}
    # Como me refiero a cada elemento de la lista? 
    {{ $clave }}
    {{ $valor }}
{{ end }}



{{ range $tipo_nodo, $especificacion := dict "master" .Values.elasticsearch.master "ingest" .Values.elasticsearch.ingest "coordinator" .Values.elasticsearch.coordinator "data" .Values.elasticsearch.data }}
{{$tipo_nodo}}
{{$especificacion}}

{{ end }}