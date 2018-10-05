#!/bin/bash
set -ex

install_secret() {
  $1/util/install-secret.sh $2
}

create_dashboard() {
  $1/util/create-dashboards.sh
}

install_prometheus() {
  helm install --name prometheus --namespace $1 \
    -f $2/config/prometheus.yml \
    $2/stable/prometheus
}

install_grafana(){
  helm install --name=grafana --namespace=$1 \
    -f $2/config/grafana.yml \
    $2/stable/grafana
}

if [ $# -ne 2 ];
then
  echo "./install.sh [namespace] [domain]"
  exit 1
fi

BASEDIR=$(dirname "$0")

namespace=$1
domain=$2


#Create namespace
kubectl create namespace prometheus --dry-run -o yaml | kubectl apply -f -
install_secret ${BASEDIR} $domain
create_dashboard ${BASEDIR}
kubectl apply -f ${BASEDIR}/config/prometheus-firehose-exporter.yml 
install_prometheus ${namespace} ${BASEDIR}
install_grafana ${namespace} ${BASEDIR}
