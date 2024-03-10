#!/bin/bash

# Get the external IP address of the LoadBalancer
EXTERNAL_IP=$(kubectl get svc -n ingress-nginx nginx-ingress-nginx-controller -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Output the external IP address
echo "{\"result\": \"$EXTERNAL_IP\"}"
