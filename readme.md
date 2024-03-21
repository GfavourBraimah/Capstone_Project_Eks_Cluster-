![prov](/images/alt.svg)

## Microservice Sockshop Deployment 

Microservices architecture is an approach to software development where a large application is broken down into smaller, independent services that communicate with each other through APIs (Application Programming Interfaces). Each service focuses on a specific business capability and can be developed, deployed, and scaled independently. This architecture promotes modularity, agility, scalability, and easier maintenance compared to traditional monolithic applications. It allows teams to work on different services concurrently, fosters rapid deployment and updates, and enables flexibility in technology choices for each service.

The Sock Shop application is a popular reference microservices-based application used for demonstrating various concepts related to cloud-native development, container orchestration, and DevOps practices. It's a fictional e-commerce platform for buying socks, consisting of multiple microservices that handle different parts of the application functionality.

This project aims to deploy a microservices-based architecture application on Kubernetes using an Infrastructure as Code (IaC) approach. The application is based on the Socks Shop example microservice application.

## Project Structure

 ```
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
│   │   ├── .....
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
│   ├── terraform.tfvars
├── aws_eks/
│   ├── main.tf
│   ├── outputs.tf
│   ├── variable.tf
│   
├── images/
│   ├── (optional)
├── readme.md
│
├── terraform.tfstate

 ```


 ## Components
* Jenkins_CICD/: Contains Kubernetes manifests, Jenkins pipeline scripts, and monitoring configurations.
* Jenkins_Server/: Terraform scripts for provisioning a Jenkins server.
* aws_eks/: Terraform scripts for provisioning an AWS EKS cluster.
* images/: Placeholder directory for images or resources.
* readme.md: This README file.


## Deployment Process
* Eks-Jenkins:
  - This helps to build the EKS clusters with a 'create' parameter.
  - Get the cluster name and the region and update it inside the Jenkinsfile as the --name and --region.  
* Jenkins Pipeline
* Build: Initiates the build process.
* Deploy NGINX Ingress: Deploys NGINX Ingress Controller and configures it.
* Configure DNS: Uses Terraform to configure DNS settings.
* Deploy Sock Shop: Deploys the Socks Shop application microservices.
* Deploy Frontend Service: Configures TLS certificates and deploys frontend services.
* Deploy Prometheus Manifests: Deploys monitoring tools like Prometheus and Grafana.

 ## Infrastructure as Code (IaC)
* Terraform Scripts: Manages infrastructure resources (AWS EKS cluster, Jenkins server).

## Continuous Integration and Continuous Deployment (CI/CD)
Jenkins pipeline scripts automate the build, test, and deployment processes.
AWS credentials are used for authentication and authorization.

## Monitoring and Metrics
Utilizes Prometheus and Grafana for monitoring and visualization.
Kubernetes monitoring tools monitor cluster health and performance.



## Getting Started
1. Clone this repository.

```
       git clone https://github.com/GfavourBraimah/Capstone_Project_Eks_Cluster-
```

2. Go into the Jenkins_Server and start up the Jenkins server instance 
```
      cd Jenkins_Server
       terraform init  
       terraform apply --auto-approve
```
This will create the VPC (and all its other components), I'm using  a new  keypair I just crrated  with it. You can change the keypair name in the server.tf file. There's also a script to install all the required packages on the server . You can find it in the "install.sh" When the infrastructure is complete, the public IP address of the server will be displayed. You can use this to access the server. http://<public-ip-address>:8080. SSH into the server and display the required password to unlock Jenkins. You can use this to login to the server.

Get the jenkins password, inside the ubuntu instance run this command 
```
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Now paste the password in the jenkins application then you are in 

3. Configure AWS credentials in Jenkins.
  - Option 1: Inside Jenkins UI, navigate to "Manage Jenkins" > "Credentials" > "Global" and add your credentials.

  - Option 2: SSH into the Jenkins server and run aws configure to set AWS credentials. 
 ```
   sudo su - jenkins
   aws configure
```

4. Build and deploy the pipelines:

 * First Pipeline (Eks-Jenkinsfile): Create EKS clusters and configure them.
 * Second Pipeline (Jenkinsfile): Deploy DNS, ingress controller, and application.

5. Cleanup:

Use the first pipeline (Eks-Jenkinsfile) with "destroy" parameter to delete clusters and resources when no longer needed.



## MONITORING THE APPLICATIONS WITH PROMETHEUS
There are configuration files to deploy prometheus and grafana in the jenkins-pipeline/manifests-monitoring folder. You can use these to monitor the applications. To access the prometheus dashboard, you can use the following command on your jenkins server.

* Prometheus Dashboard:
```
   kubectl port-forward svc/prometheus-server 8081:9090 -n monitoring --address 0.0.0.0
```
Grafana Dashboard:
```
    kubectl port-forward svc/grafana 8082:80 -n monitoring --address 0.0.0.0
```    

![prov](/images/sockshop.png)
![prov](/images/shockapp2.png)
