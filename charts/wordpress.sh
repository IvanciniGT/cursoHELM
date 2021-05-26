#!/bin/bash

export NOMBRE_DESPLIEGUE=miwordpress
export NOMBRE_REPO=bitnami
export URL_REPO=https://charts.bitnami.com/bitnami
export NOMBRE_CHART=wordpress
export NAMESPACE=wordpress

function install(){
    helm repo add $NOMBRE_REPO $URL_REPO
    
    cat wordpress.extra.yaml | kubectl apply -n $NAMESPACE -f -

    helm install $NOMBRE_DESPLIEGUE \
         $NOMBRE_REPO/$NOMBRE_CHART \
         --namespace $NAMESPACE \
         --create-namespace \
         -f $NOMBRE_CHART.values.yaml
         # --set "primary.persistence.storageClass=cluster-nfs" # RUINA !!!!
    
}

function uninstall(){
    helm uninstall $NOMBRE_DESPLIEGUE --namespace $NAMESPACE
}

function full_uninstall(){
    uninstall
    cat wordpress.extra.yaml | kubectl delete -n $NAMESPACE -f -
}

function download(){
    helm pull $NOMBRE_REPO/$NOMBRE_CHART --untar
}

while [[ $# != 0 ]]
do
    if [[ "$1" == "--install" ]]
    then
        install
        shift
    elif [[ "$1" == "--uninstall" ]]
    then
        uninstall
        shift
    elif [[ "$1" == "--full-uninstall" ]]
    then
        full_uninstall
        shift
    elif [[ "$1" == "--download" ]]
    then
        download
        shift
    else
        echo Opcion invalida. Se admiten los parametros: --install, --uninstal, --full-uninstall y --download
        exit 1
    fi
done


# kubectl get secret mimariadb -n mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode
# okkWrr80XQ
# kubectl exec -it mimariadb-0 -n mariadb -- bash
# env | database # my_database
# mysql -u root -p
# use my_database
# CREATE TABLE PRUEBA (CAMPO_PRUEBA INT);  
# insert into PRUEBA (CAMPO_PRUEBA) VALUES (45);                                                                                                     