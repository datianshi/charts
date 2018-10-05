#!/bin/bash

# $1 domain
tmpdir=$(dirname $(mktemp -u))
domain=$1
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${tmpdir}/prometheus.key -out ${tmpdir}/prometheus.crt -subj "/CN=prometheus.${DOMAIN}"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${tmpdir}/alertmanager.key -out ${tmpdir}/alertmanager.crt -subj "/CN=alertmanager.${DOMAIN}"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${tmpdir}/pushgateway.key -out ${tmpdir}/pushgateway.crt -subj "/CN=pushgateway.${DOMAIN}"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${tmpdir}/grafana.key -out ${tmpdir}/grafana.crt -subj "/CN=grafana.${DOMAIN}"
kubectl create secret tls prometheus-server-tls --cert=${tmpdir}/prometheus.crt --key=${tmpdir}/prometheus.key --dry-run -o yaml | kubectl apply -f -
kubectl create secret tls alertmanager-server-tls --cert=${tmpdir}/alertmanager.crt --key=${tmpdir}/alertmanager.key --dry-run -o yaml | kubectl apply -f -
kubectl create secret tls pushgateway-server-tls --cert=${tmpdir}/pushgateway.crt --key=${tmpdir}/pushgateway.key --dry-run -o yaml | kubectl apply -f -
kubectl create secret tls grafana-server-tls --cert=${tmpdir}/grafana.crt --key=${tmpdir}/grafana.key --dry-run -o yaml | kubectl apply -f -
