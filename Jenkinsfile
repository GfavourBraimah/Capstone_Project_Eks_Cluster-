#!/usr/bin/env groovy

pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'us-west-2'
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

        stage("Copy .kube Folder into Jenkins Container") {
            steps {
                script {
                   
                        // Install kubectl
                       
                        // Install aws-iam-authenticator
                        sh "curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator"
                        sh "chmod +x ./aws-iam-authenticator"
                        sh "mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator"
                        
                        // Add aws-iam-authenticator to PATH
                        sh "mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin"
                        sh "echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc"
                        sh 'kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml'

                    }
                }
            }
        }
   
        stage("Deploy nginx Ingress") {
            steps {
                script {
                    dir ('Jenkins_CICD/k8s') {
                        sh "aws eks --region us-west-2 update-kubeconfig --name  ${CLUSTER_NAME}"
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
                        sh "aws eks --region us-west-2 update-kubeconfig --name  ${CLUSTER_NAME}"
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
                        sh "aws eks --region us-west-2 update-kubeconfig --name  ${CLUSTER_NAME}"
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
                        sh "aws eks --region us-west-2 update-kubeconfig --name  ${CLUSTER_NAME}"
                        sh 'kubectl apply -f manifests-monitoring/'
                    }
                }
            }
        }
    }
}
