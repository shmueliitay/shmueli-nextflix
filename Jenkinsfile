pipeline {
    agent any

    environment {
        ECR_REPO = "shmueli-nexflix"
        AWS_REGION = "eu-central-1"
        STAGING_EC2 = "ubuntu@63.179.106.250"
        PRODUCTION_EC2 = "ubuntu@3.73.86.50"
        DOCKER_IMAGE_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${ECR_REPO}:${DOCKER_IMAGE_TAG} ."
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin 630019796862.dkr.ecr.eu-central-1.amazonaws.com/shmueli-nextflix.amazonaws.com
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker tag ${ECR_REPO}:${DOCKER_IMAGE_TAG} 630019796862.dkr.ecr.eu-central-1.amazonaws.com/shmueli-nextflix.amazonaws.com/${ECR_REPO}:${DOCKER_IMAGE_TAG}"
                    sh "docker push 630019796862.dkr.ecr.eu-central-1.amazonaws.com/shmueli-nextflix.amazonaws.com/${ECR_REPO}:${DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def target = env.CHANGE_ID ? STAGING_EC2 : PRODUCTION_EC2
                    sh """
                    ssh -o StrictHostKeyChecking=no ${target} \\
                        'docker pull 630019796862.dkr.ecr.eu-central-1.amazonaws.com/shmueli-nextflix.amazonaws.com/${ECR_REPO}:${DOCKER_IMAGE_TAG} && \\
                         docker stop nextflix || true && docker rm nextflix || true && \\
                         docker run -d --name nextflix -p 3000:3000 630019796862.dkr.ecr.eu-central-1.amazonaws.com/shmueli-nextflix.amazonaws.com/${ECR_REPO}:${DOCKER_IMAGE_TAG}'
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}

