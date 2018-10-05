#!/bin/bash
set -ex

BASEDIR=$(dirname "$0")

helm delete --purge prometheus
helm delete --purge grafana
kubectl delete -f ${BASEDIR}/config/prometheus-firehose-exporter.yml
kubectl delete secret prometheus-server-tls
kubectl delete secret pushgateway-server-tls
kubectl delete secret alertmanager-server-tls
kubectl delete secret grafana-server-tls
kubectl delete namespace prometheus
