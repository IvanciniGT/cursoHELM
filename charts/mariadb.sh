#!/bin/bash

export NOMBRE_DESPLIEGUE=mimariadb
export NOMBRE_REPO=bitnami
export URL_REPO=https://charts.bitnami.com/bitnami
export NOMBRE_CHART=mariadb
export NAMESPACE=mariadb

function install(){
    helm repo add $NOMBRE_REPO $URL_REPO
    helm install $NOMBRE_DESPLIEGUE \
         $NOMBRE_REPO/$NOMBRE_CHART \
         --namespace $NAMESPACE \
         --create-namespace \
         -f mariadb.values.yaml
         # --set "primary.persistence.storageClass=cluster-nfs" # RUINA !!!!
        
}

function uninstall(){
    helm uninstall $NOMBRE_DESPLIEGUE --namespace $NAMESPACE
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
    elif [[ "$1" == "--download" ]]
    then
        download
        shift
    else
        echo Opcion invalida. Se admiten los parametros: --install, --uninstall y --download
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