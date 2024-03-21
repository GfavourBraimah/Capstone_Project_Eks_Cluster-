## Microservice Sockshop Deployment 

Microservices architecture is an approach to software development where a large application is broken down into smaller, independent services that communicate with each other through APIs (Application Programming Interfaces). Each service focuses on a specific business capability and can be developed, deployed, and scaled independently. This architecture promotes modularity, agility, scalability, and easier maintenance compared to traditional monolithic applications. It allows teams to work on different services concurrently, fosters rapid deployment and updates, and enables flexibility in technology choices for each service.

The Sock Shop application is a popular reference microservices-based application used for demonstrating various concepts related to cloud-native development, container orchestration, and DevOps practices. It's a fictional e-commerce platform for buying socks, consisting of multiple microservices that handle different parts of the application functionality.

## Overview

This project aims to deploy a microservices-based architecture application on Kubernetes using an Infrastructure as Code (IaC) approach. The application is based on the Socks Shop example microservice application.


---
   ├── Jenkins_CICD/
│   ├── k8s/
│   │   ├── cluster-issuer.yaml
│   │   ├── sock-shop.yaml
│   │   ├── sock-shop-ingress.yaml
│   │   ├── get_external_ip.sh
│   │   ├── route53.tf
│   │   ├── terraform.tf
│   │   
│   ├── manifests-monitoring/
│   │   ├── 00-monitoring-ns.yaml
│   │   ├── 01-prometheus-sa.yaml
│   │   ├── ...
├── Jenkinsfile
├── Eks-Jenkinsfile
├── Jenkins_Server/
│   ├── install.sh
│   ├── my_jenk.pem
│   ├── server.tf
│   ├── provider.tf
│   ├── variable.tf
│   ├── vpc.tf
│   ├── outputs.tf
├── aws_eks/
│   ├── main.tf
│   ├── outputs.tf
│   ├── variable.tf
├── images/
│   ├── (optional)
├── readme.md
│
├── terraform.tfstate

---

 ## Components
 * Jenkins_CICD/: Contains Kubernetes manifests, Jenkins pipeline scripts, and monitoring configurations.
* Jenkins_Server/: Terraform scripts for provisioning a Jenkins server.
* aws_eks/: Terraform scripts for provisioning an AWS EKS cluster.
* images/: Placeholder directory for images or resources.
* readme.md: This README file.


## Deployment Process
* Jenkins Pipeline
* Build: Initiates the build process.
Deploy NGINX Ingress: Deploys NGINX Ingress Controller and configures it.
Configure DNS: Uses Terraform to configure DNS settings.
Deploy Sock Shop: Deploys the Socks Shop application microservices.
Deploy Frontend Service: Configures TLS certificates and deploys frontend services.
Deploy Prometheus Manifests: Deploys monitoring tools like Prometheus and Grafana.

 ## Infrastructure as Code (IaC)
Terraform Scripts: Manages infrastructure resources (AWS EKS cluster, Jenkins server).

## Continuous Integration and Continuous Deployment (CI/CD)
Jenkins pipeline scripts automate the build, test, and deployment processes.
AWS credentials are used for authentication and authorization.

## Monitoring and Metrics
Utilizes Prometheus and Grafana for monitoring and visualization.
Kubernetes monitoring tools monitor cluster health and performance.

## Getting Started
Clone this repository.

---
  git clone 
--- 
      
Configure AWS credentials in Jenkins.
Create Jenkins pipelines using the provided Jenkinsfiles.
Run Terraform scripts to provision infrastructure.
Deploy applications using Kubernetes manifests.
