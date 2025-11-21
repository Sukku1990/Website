pipeline {
    agent any
	environment {
        EC2_USER = "ubuntu"
        EC2_HOST = "98.81.82.26"
        SSH_KEY  = "ec2-ssh-key"     // Jenkins Credential ID
    }

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

        stage('Transfer Code to EC2') {
            steps {
                echo "Copying app files to EC2..."
                sshagent(credentials: ["${SSH_KEY}"]) {
                    sh """
                        rsync -avz -e "ssh -o StrictHostKeyChecking=no" ./ \
                        ${EC2_USER}@${EC2_HOST}:/home/ubuntu/website/
                    """
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                echo "Deploying Docker container on EC2..."
                sshagent(credentials: ["${SSH_KEY}"]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                        cd /home/ubuntu/website &&
                        
                        echo "Stopping old container..." &&
                        sudo docker stop website || true &&
                        sudo docker rm website || true &&
                        
                        echo "Building image on EC2..." &&
                        sudo docker build -t website . &&
                        
                        echo "Running new container..." &&
                        sudo docker run -d --name website -p 82:80 website
                    '
                    """
                }
            }
        }
    }
}
