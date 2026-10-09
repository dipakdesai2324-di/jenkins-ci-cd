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
                sh 'python3 -m pip install pytest'
                sh 'python3 -m pytest tests/'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t jenkins-ci-cd-demo:${BUILD_NUMBER} .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'bash scripts/deploy.sh'
            }
        }
    }
    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
        }
        failure {
            echo 'CI/CD pipeline failed. Check the console output.'
        }
        always {
            echo 'Pipeline execution finished.'
        }
    }
}
