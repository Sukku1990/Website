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
                sh 'sudo docker build -t website .'
            }
        }

        stage('Stop Old Container') {
            steps {
                script {
                    echo "Stopping old container if running..."

                    // If container exists, stop & remove it
                    sh '''
                    if [ "$(sudo docker ps -aq -f name=mywebsite)" ]; then
                        sudo docker stop mywebsite || true
                        sudo docker rm mywebsite || true
                    fi
                    '''
                }
            }
        }

        stage('Run New Container') {
            steps {
                echo "Running new container..."
                sh 'sudo docker run -d --name mywebsite -p 82:80 website'
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
