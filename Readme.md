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