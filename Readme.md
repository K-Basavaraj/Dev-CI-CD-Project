# CI/CD: Continuous Integration and Continuous Deployment/Development

## 1. What is Continuous Integration (CI)?

Continuous Integration (CI) is the practice of frequently merging code changes from developers into a shared repository.  
The main purpose of CI is to **automate the integration process** and catch issues early.

When code is integrated, the CI pipeline typically performs these steps:

- **Install dependencies**  
- **Run tests** (e.g., unit tests)  
- **Build the application / generate artifacts** (used later for deployment or as input to other stages)  
- **Scan code quality** (bugs, vulnerabilities, style issues)  
- **Detect build issues early**  

This process reduces manual effort, improves efficiency, and ensures that errors are identified quickly.

### Benefits of CI
- Early bug detection  
- Faster feedback loops for developers  
- Reduced manual tasks  
- Reliable and consistent builds  

### Tools used for CI
Some popular tools are:  
- **Jenkins**  
- **GitHub Actions**  
- **Azure DevOps**  
- **GitLab CI/CD**  
- **Bitbucket Pipelines**  

---

## 2. Jenkins Overview

**Jenkins** is one of the most popular CI servers.  

- It is a lightweight **web server**.  
- By default, Jenkins is minimal, but it can be extended using **plugins**.  
- Plugins allow Jenkins to integrate with other tools like:  
  - **Git** (version control)  
  - **Bitbucket**  
  - **SonarQube** (code quality)  
  - **Node.js, Python, Java** (language support)  

> Example: If your project uses Git, you can install the **Git plugin** to connect Jenkins with your repository.
