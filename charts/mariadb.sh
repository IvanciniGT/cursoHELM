#!/bin/bash

export NOMBRE_DESPLIEGUE=mimariadb
export NOMBRE_REPO=bitnami
export URL_REPO=https://charts.bitnami.com/bitnami
export NOMBRE_CHART=mariadb

function install(){
    helm repo add $NOMBRE_REPO $URL_REPO
    helm install $NOMBRE_DESPLIEGUE $NOMBRE_REPO/$NOMBRE_CHART
}

function uninstall(){
    helm uninstall $NOMBRE_DESPLIEGUE
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
    else
        echo Opcion invalida. Se admiten los parametros: --install y --uninstall
        exit 1
    fi
done