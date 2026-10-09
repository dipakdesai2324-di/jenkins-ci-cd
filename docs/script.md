# Explanation of deploy.sh

## 1. What is deploy.sh?
deploy.sh is a Bash shell script used to deploy a Dockerized application.
In our Jenkins CI/CD project, Jenkins executes this script after successfully building the Docker image. The script stops and removes the previous application container, if one exists, and starts a new container using the newly built image.
This keeps the deployment commands separate from the Jenkins pipeline configuration.

## 2. Script Location
The script is stored inside the scripts directory at the root of the repository.

## 3. Complete Script
#!/bin/bash
set -e
IMAGE_NAME="jenkins-ci-cd-demo:${BUILD_NUMBER:-latest}"
CONTAINER_NAME="jenkins-demo"
echo "Stopping the previous container if it exists..."
if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
fi
echo "Starting the new application container..."
docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p 5000:5000 \
    "$IMAGE_NAME"
echo "Deployment completed successfully."
echo "Application is available on port 5000."

## 4. Line-by-Line Explanation
### #!/bin/bash
This is called a shebang. It tells the operating system to execute the script using the Bash shell.

### set -e
This instructs Bash to exit when a command fails in situations covered by this option.
It helps prevent the script from continuing with deployment commands after an unsuccessful operation.

### IMAGE_NAME="jenkins-ci-cd-demo:${BUILD_NUMBER:-latest}"
This defines the Docker image to deploy.
* jenkins-ci-cd-demo is the image name.
* BUILD_NUMBER is an environment variable provided by Jenkins.
* If BUILD_NUMBER is unset or empty, `latest` is used as the tag.
For example, if Jenkins is running build number 5, the image name becomes:
jenkins-ci-cd-demo:5
The tag must match the image built by the Jenkins pipeline.

### CONTAINER_NAME="jenkins-demo"
This defines a fixed name for the application container.
The script uses this name to find and replace the previous container during deployment.

### echo
The echo command prints messages to the terminal or Jenkins console output.
For example:
echo "Starting the new application container..."
This helps us understand which deployment step is currently running.

### if docker container inspect ...
if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
This checks whether a Docker container with the specified name exists.
* docker container inspect retrieves information about the container.
* >/dev/null discards standard output.
* 2>&1 redirects error output to the same destination.
If the container exists, the commands inside the if block execute.

### docker stop "$CONTAINER_NAME"
This stops the existing container so it no longer runs the previous application version.

### docker rm "$CONTAINER_NAME"
This removes the stopped container.
Removing a container does not automatically delete the Docker image it was created from.

### docker run -d
This creates and starts a new container from the specified Docker image.
The -d option runs the container in detached mode, meaning it runs in the background.

### --name "$CONTAINER_NAME"
Assigns the name `jenkins-demo` to the new container.

### --restart unless-stopped
Configures Docker to restart the container after a Docker daemon or host restart, unless the container was explicitly stopped.

### -p 5000:5000
Maps port 5000 on the Docker host to port 5000 inside the container.
The application must listen on `0.0.0.0:5000` inside the container for this mapping to work.

### "$IMAGE_NAME"
Specifies the Docker image used to create the new container.
For example:
jenkins-ci-cd-demo:5

### Final echo commands
These display messages indicating that the script reached the end and that the application is intended to be available on port 5000.
The success message alone does not verify that the application is healthy or responding correctly.

## 5. How It Works with Jenkins
The Jenkinsfile calls the script in the deployment stage:
stage('Deploy') {
    steps {
        sh 'bash scripts/deploy.sh'
    }
}
The overall workflow is:
Jenkins Pipeline-->Build Docker Image-->Set Jenkins BUILD_NUMBER-->Execute deploy.sh-->Check Existing Container
-->Stop and Remove Old Container-->Start New Container-->Start New Container-->Deployment Script Finishes
The script expects the Docker image to have already been built on the same Docker host.

## 6. Why Do We Use a Separate Deployment Script?
Keeping deployment commands in a separate script provides several benefits:
* **Reusability:** The script can be executed manually or from different Jenkins jobs.
* **Maintainability:** Deployment logic can be updated without making the Jenkinsfile unnecessarily long.
* **Readability:** The Jenkinsfile describes the pipeline stages, while the shell script handles container replacement.
* **Troubleshooting:** We can inspect the script's output in Jenkins Console Output to identify deployment failures.

## 7. Important Considerations
* The Jenkins agent must have Docker installed and permission to run Docker commands.
* The image name and tag must match the image produced by the Docker Build stage.
* The application must listen on `0.0.0.0:5000`.
* Port 5000 must be available on the Docker host.
* If the new container fails to start, the previous container has already been removed. This basic script does not provide automatic rollback.
* The script does not perform a health check; a successful `docker run` command does not guarantee that the application is functioning correctly.

## 8. Summary

deploy.sh automates replacing an existing Docker container with a newly built application image. Jenkins invokes the script during the Deploy stage, and the script performs the container operations on the Docker host where it runs.
