pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'python3 -m pip install -r app/requirements.txt'
            }
        }

        stage('Test') {
            steps {
                sh 'python3 -m pytest tests/'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t jenkins-ci-cd-demo:${BUILD_NUMBER} .'
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                    docker stop jenkins-demo || true
                    docker rm jenkins-demo || true

                    docker run -d \
                      --name jenkins-demo \
                      -p 5000:5000 \
                      jenkins-ci-cd-demo:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the console logs.'
        }
    }
}
