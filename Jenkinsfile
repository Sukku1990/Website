pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                echo "Pulling code from GitHub..."
                git branch: 'master', url: 'https://github.com/Sukku1990/Website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh ' docker build -t website .'
            }
        }

        stage('Stop Old Container') {
            steps {
                script {
                    echo "Stopping old container if running..."

                    // If container exists, stop & remove it
                    sh '''
                    if [ "$(sudo docker ps -aq -f name=website)" ]; then
                         docker stop website || true
                         docker rm website || true
                    fi
                    '''
                }
            }
        }

        stage('Run New Container') {
            steps {
                echo "Running new container..."
                sh ' docker run -d --name website -p 82:80 website'
            }
        }
    }

    post {
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed!"
        }
    }
}
