#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'eu-west-3'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
         CLUSTER_NAME = ''  // Initialize CLUSTER_NAME variable
    }
    stages {
        stage('Build') {
            steps {
                sh 'echo "Building..."'
            }
        }

        stage("Create EKS Infrastructure") {
            steps {
                script {
                    dir ('Jenkins_CICD/aws_eks') {
                        
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                        CLUSTER_NAME = sh(script: 'terraform output -raw cluster_name', returnStdout: true).trim()
                        echo "Cluster name: ${CLUSTER_NAME}"
                    }
                }
            }
        }
        
      
       
        stage("Deploy nginx Ingress") {
            steps {
                script {
                    dir ('Jenkins_CICD/k8s') {
                        sh "aws eks --region eu-west-3 update-kubeconfig --name  ${CLUSTER_NAME}"
                        sh 'kubectl create ns ingress-nginx'
                        sh 'helm repo add ingress nginx https://kubernetes.github.io/ingress-nginx'
                        sh 'helm install nginx ingress-nginx/ingress-nginx -n ingress-nginx' // deployed nginx-ingress-controller in the ingress-nginx namespace
                        sh 'chmod +x get_external_ip.sh'
                        sh './get_external_ip.sh'
                        sh 'kubectl get deploy -n ingress-nginx' // verify deployment 
                        sh 'kubectl get svc -n ingress-nginx'     // check the service and ensure a loadbalancer is created 
                    }
                }
            }
        }

           stage("Configure DNS") {
            steps {
                script {
                    dir ('Jenkins_CICD/k8s') {
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
                        sh "aws eks --region eu-west-3 update-kubeconfig --name  ${CLUSTER_NAME}"
                        sh 'kubectl apply -f sock-shop.yaml'
                        sh 'kubectl get deploy -n sock-shop'
                        sh 'kubectl get svc -n sock-shop'
                    }
                }
            }
        }

        stage("Deploy the frontend service ") {
            steps {
                script {
                    dir ('Jenkins_CICD/k8s') {
                        sh "aws eks --region eu-west-3 update-kubeconfig --name  ${CLUSTER_NAME}"
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
                        sh "aws eks --region eu-west-3 update-kubeconfig --name  ${CLUSTER_NAME}"
                        sh 'kubectl apply -f manifests-monitoring/'
                    }
                }
            }
        }
    }
}


