pipeline {

    agent any

    environment {
        EC2_USER = "ubuntu"
        EC2_HOST = "34.202.236.240"
        SSH_KEY  = "ec2-ssh-key"
    }

    stages {

        stage('Checkout Code') {
            steps {

                echo "Pulling code from GitHub..."

                git branch: 'master',
                    url: 'https://github.com/Sukku1990/Website.git'
            }
        }

        stage('Transfer Code to EC2') {
            steps {

                echo "Copying app files to EC2..."

                sshagent(credentials: ["${SSH_KEY}"]) {

                    sh """
                    rsync -avz \
                    --exclude '.git' \
                    -e "ssh -o StrictHostKeyChecking=no" ./ \
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

                    echo "Removing old container..." &&
                    sudo docker rm website || true &&

                    echo "Removing old image..." &&
                    sudo docker rmi website || true &&

                    echo "Building Docker image..." &&
                    sudo docker build -t website . &&

                    echo "Running new container..." &&
                    sudo docker run -d \
                        --name website \
                        -p 82:80 \
                        website
                    '
                    """
                }
            }
        }
    }
}
