#!/bin/bash

BASEDIR=$(dirname "$0")

kubectl create configmap kube-dashboard --from-file=${BASEDIR}/../dashboards/kubernetes.json -n prometheus --dry-run  -o yaml | kubectl apply -f -
kubectl create configmap cf-kpis-dashboard --from-file=${BASEDIR}/../dashboards/cf_kpis.json -n prometheus --dry-run  -o yaml | kubectl apply -f -
