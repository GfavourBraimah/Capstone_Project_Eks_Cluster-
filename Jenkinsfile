#!/usr/bin/env groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'echo "Building..."'
            }
        }


        stage("Deploy nginx Ingress") {
            steps {
                script {
                    
                    dir ('Jenkins_CICD/k8s') {
                        sh ('aws eks update-kubeconfig --name bog-eks-fe8DPRlC --region us-west-2')
                        sh 'kubectl create ns ingress-nginx'
                        sh 'helm repo add ingress nginx https://kubernetes.github.io/ingress-nginx'
                        sh 'helm install nginx ingress-nginx/ingress-nginx -n ingress-nginx' // Deploy nginx-ingress-controller in the ingress-nginx namespace
                        sh 'chmod +x get_external_ip.sh'
                        sh './get_external_ip.sh'
                        sh 'kubectl get deploy -n ingress-nginx' // Verify deployment 
                        sh 'kubectl get svc -n ingress-nginx'     // Check the service and ensure a load balancer is created 
                    }
                }
            }
        }

        stage("Configure DNS") {
            steps {
                script {
                    dir ('Jenkins_CICD/k8s') {
                        sh ('aws eks update-kubeconfig --name bog-eks-fe8DPRlC --region us-west-2')
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage("Deploy the socks shop application") {
            steps {
                script {
                    
                    dir ('Jenkins_CICD/k8s') {
                        sh ('aws eks update-kubeconfig --name bog-eks-fe8DPRlC --region us-west-2')
                        sh 'kubectl apply -f sock-shop.yaml'
                        sh 'kubectl get deploy -n sock-shop'
                        sh 'kubectl get svc -n sock-shop'
                    }
                }
            }
        }

        stage("Deploy the frontend service") {
            steps {
                script {
                    
                    dir ('Jenkins_CICD/k8s') {
                        sh ('aws eks update-kubeconfig --name bog-eks-fe8DPRlC --region us-west-2')
                        sh 'kubectl create namespace cert-manager'
                        sh 'kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml'
                        sh 'kubectl get pods --namespace cert-manager'
                        sh 'kubectl apply --namespace sock-shop -f cluster-issuer.yaml'
                        sh 'kubectl apply -f sock-shop-ingress.yaml'
                        sh 'kubectl get services -n sock-shop'
                    }
                }
            }
        }

        stage("Deploy Prometheus Manifests") {
            steps {
                script {
                    
                    dir ('Jenkins_CICD/') {
                        sh ('aws eks update-kubeconfig --name bog-eks-fe8DPRlC --region us-west-2')
                        sh 'kubectl apply -f manifests-monitoring/'
                    }
                }
            }
        }
    }
}