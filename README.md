# Jenkins CI/CD Pipeline with Docker

## Project Overview

This project demonstrates a Jenkins Declarative CI/CD pipeline integrated with GitHub and Docker.

The pipeline automatically checks out application source code from GitHub, installs dependencies, runs tests, builds a Docker image, and deploys the application as a Docker container.

## Tools Used 

* Git
* GitHub
* Jenkins
* Python
* Docker
* Linux

## CI/CD Flow

GitHub → Jenkins → Checkout → Build → Test → Docker Build → Docker Run

## Pipeline Stages

### 1. Checkout

Jenkins checks out the application source code from the GitHub repository.

### 2. Build

The pipeline installs the application's required dependencies.

### 3. Test

Jenkins executes the application test cases and stops the pipeline if the tests fail.

### 4. Docker Build

After successful testing, Jenkins creates a Docker image using the Dockerfile.

The image is tagged using the Jenkins build number.

### 5. Docker Run

Jenkins stops and removes the previous container if it exists and starts a new container using the newly created Docker image.

## Jenkins Configuration

The Jenkins job is configured as a Pipeline job and uses the Jenkinsfile stored in the GitHub repository.

A GitHub webhook can be configured to trigger the Jenkins pipeline whenever new code is pushed to the repository.

## How to Access the Application
After a successful pipeline execution, the application runs on port 5000.
Example: http://SERVER_IP:5000

## Key Jenkins Concepts Demonstrated

* Declarative Pipeline
* Jenkinsfile
* Pipeline stages
* GitHub integration
* Webhook-triggered builds
* Build numbers
* Environment variables
* Build failure handling
* Docker integration
* Post-build actions
