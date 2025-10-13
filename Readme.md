# EXPENSE-DEV Deployment

This repository documents the **infrastructure provisioning** of the Expense Application using **Terraform** and **Jenkins CI/CD**.

**[Infra-CI/CD Repository](https://github.com/K-Basavaraj/Dev-CI-CD-Project)**  
   - Contains infrastructure provisioning scripts using **Terraform**.  
   - Jenkins pipelines to provision and destroy infra resources.  
   - AWS resources managed include: VPC, Security Groups, Bastion Host, RDS, EKS Cluster, ECR, ACM, ALB, CDN.  


## 🧱 Infrastructure Setup Overview
The below diagram represents the **EXPENSE-DEV-INFRA-CI/CD** setup configured through **Jenkins** using **Terraform**.
![alt text](infra-cicd.drawio.svg)
---
### Dependency Flow

- **10-VPC** is the **upstream** for **20-SG (Security Group)**.  
- **20-SG** acts as the common upstream for:
  - **30-Bastion**
  - **40-RDS**
  - **50-EKS**
  - **70-ECR**
  - **60-ACM**
- **60-ACM** serves as the upstream for:
  - **80-ALB**
  - **90-CDN**

This ensures resources are deployed in the correct order while allowing independent components to run concurrently.
---
### Pipeline Logic Summary

- The Jenkins pipeline begins by provisioning the **VPC** and **Security Group**.
- After SG creation:
  - The following jobs execute **in parallel** since they are independent:  
    - **Bastion**  
    - **RDS**  
    - **EKS**  
    - **ECR**
  - Once the parallel stage completes, the following jobs run **sequentially**:  
    - **ACM** → **ALB** → **CDN**
- The pipeline supports both **apply** and **destroy** actions via the `ACTION` parameter.
- A **timeout** and **concurrent build lock** are used to ensure stability.
- **Color-coded console logs** improve pipeline readability.

- Built-in features include:
  - **Timeout control** (30 minutes)
  - **Disable concurrent builds**
  - **ANSI colorized output**

## Plugins used: 

* pipeline stage view 
* pipeline utility steps
* aws credential Allows storing Amazon IAM credentials within the Jenkins Credentials API. 
* Pipeline: AWS Steps This plugins adds Jenkins pipeline steps to interact with the AWS API.
* AnsiColorVersion Adds ANSI coloring to the Console Output
* Rebuilder This plugin is for rebuilding a job using the same parameters.
---
### Key Highlights

-  **Parallel execution** reduces build time by provisioning independent resources simultaneously.  
-  **Sequential stages** maintain dependency order for ACM → ALB → CDN.  
-  **Post actions** ensure cleanup and consistent logging after every pipeline run.  
-  **Parameter-driven workflow** allows easy switching between environment creation and destruction.

---
> This setup ensures efficient, modular, and dependency-aware infrastructure provisioning for the EXPENSE-DEV environment.

* Make sure infra is created. 
* Every resource should have dev in its name, so that it will not overlap with prod resources.

Once infra is setup. We need to configure ingress controller to provide internet access to our expense application.

We are using bastion as our EKS client, so it will have
* K9S
* kubectl
* helm
* aws configure

## RDS Configuration
* Since we are using RDS instead of MySQL image, we need to configure RDS manually, we are creating schema as part of RDS but table and user should be created.
* Make sure MySQL instance allows port no 3306 from bastion

## LogintoBastion
```
 mysql -h expense-dev.czn6yzxlcsiv.us-east-1.rds.amazonaws.com -u root -pExpenseApp1
```
```
 USE transactions;
```
```
 CREATE TABLE IF NOT EXISTS transactions (
     id INT AUTO_INCREMENT PRIMARY KEY,
     amount INT,
     description VARCHAR(255)
 );
```
```
 CREATE USER IF NOT EXISTS 'expense'@'%' IDENTIFIED BY 'ExpenseApp@1';
```
```
 GRANT ALL ON transactions.* TO 'expense'@'%';
```
```
 FLUSH PRIVILEGES;
 EXIT
```

## Ingress Controller

* Login to bastion host and get the kubeconfig of EKS cluster
```
aws configure
```

```
aws eks update-kubeconfig --region us-east-1 --name expense-dev
```

```
kubectl get nodes
```

* Create namespace expense
```
kubectl create namespace expense-dev
```

* IAM policy

```
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.10.0/docs/install/iam_policy.json
```

* IAM Role created
```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```
* Create Service account. Replace your account ID.
```
eksctl create iamserviceaccount \
--cluster=expense-dev \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::688567303455:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region us-east-1 \
--approve
```

* Install aws load balancer controller drivers through helm.
# Why TargetGroupBinding with AWS Load Balancer Controller?

We installed the **AWS Load Balancer Controller** through Helm to enable Kubernetes to interact with AWS load balancing features:


```
helm repo add eks https://aws.github.io/eks-charts
```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=expense-dev \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller
```
* Make sure load balancer pods are running

```
kubectl get pods -n kube-system
NAME                                            READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-689495d45f-mwmg6   1/1     Running   0          8s
aws-load-balancer-controller-689495d45f-v78wh   1/1     Running   0          8s
aws-node-txwjc                                  2/2     Running   0          5m13s
aws-node-v9d79                                  2/2     Running   0          5m17s
coredns-789f8477df-55j2d                        1/1     Running   0          9m52s
coredns-789f8477df-74j5h                        1/1     Running   0          9m52s
eks-pod-identity-agent-9ngdt                    1/1     Running   0          5m17s
eks-pod-identity-agent-cj98g                    1/1     Running   0          5m17s
kube-proxy-7sgw7                                1/1     Running   0          6m4s
kube-proxy-8zb7z                                1/1     Running   0          6m5s
```