pipeline {
    agent any

    environment {
        ECR_REPO = "shmueli-nexflix"
        AWS_REGION = "eu-central-1"
        STAGING_EC2 = "ubuntu@<>"
        PRODUCTION_EC2 = "ubuntu@<PRODUCTION_EC2_PUBLIC_IP>"
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
                    docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.${AWS_REGION}.amazonaws.com
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker tag ${ECR_REPO}:${DOCKER_IMAGE_TAG} <AWS_ACCOUNT_ID>.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${DOCKER_IMAGE_TAG}"
                    sh "docker push <AWS_ACCOUNT_ID>.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def target = env.CHANGE_ID ? STAGING_EC2 : PRODUCTION_EC2
                    sh """
                    ssh -o StrictHostKeyChecking=no ${target} \\
                        'docker pull <AWS_ACCOUNT_ID>.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${DOCKER_IMAGE_TAG} && \\
                         docker stop nextflix || true && docker rm nextflix || true && \\
                         docker run -d --name nextflix -p 3000:3000 <AWS_ACCOUNT_ID>.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${DOCKER_IMAGE_TAG}'
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

