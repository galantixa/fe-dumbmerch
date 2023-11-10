pipeline {
    agent any

    environment {
        DOCKERUSERNAME = "galantixa"
        DOCKER_IMAGE_NAME = 'production-dumbmerch-fe'
        DOCKER_REGISTRY = 'https://registry.hub.docker.com/v2/' 
    }

    stages {
        stage('Clone') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ."
                }
            }
        }

        stage('login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('push image') {
            steps {
                script {
                    def imageTag = "${DOCKERUSERNAME}/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ${imageTag}"
                    sh "docker push ${imageTag}"
                    sh "docker rmi ${imageTag}"
                    sh "docker rmi  ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} || true"
                }
            }
        }
        stage('Update Manifest') {
            steps {
                script {
                    build job: 'fe-updatemanifest-v', parameters: [string(name: 'DOCKERTAGFE', value: env.BUILD_NUMBER)]
                }
            }
        }
    }
}