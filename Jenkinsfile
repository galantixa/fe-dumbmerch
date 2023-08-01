def branch = "staging"
def repo = "git@github.com:galantixa/fe-dumbmerch.git"
def cred = "appserver"
def dir = "~/fe-dumbmerch"
def server = "appserver@103.139.193.35"
def imagename = "dumbmerch-fe"
def dockerusername = "galantixa"

pipeline {
    agent any
    stages {
        stage('Repository pull') {
            steps {
                script {
                    sshagent(credentials: ['cred']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${server} << EOF
                                cd ${dir}
                                git checkout ${branch}
                                git pull origin ${branch}
                                exit
                            EOF
                        """
                    }
                }
            }
        }

        stage('Image build') {
            steps {
                script {
                    sshagent(credentials: ['cred']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${server} << EOF
                                cd ${dir}
                                docker build -t ${imagename}:latest .
                                exit
                            EOF
                        """
                    }
                }
            }
        }

        stage('Running the image in a container') {
            steps {
                script {
                    sshagent(credentials: ['cred']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${server} << EOF
                                cd ${dir}
                                docker container stop ${imagename} || true
                                docker container rm ${imagename} || true
                                docker run -d -p 3000:3000 --name="${imagename}" ${imagename}:latest
                                exit
                            EOF
                        """
                    }
                }
            }
        }

        stage('Image push') {
            steps {
                script {
                    sshagent(credentials: ['cred']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${server} << EOF
                                docker tag ${imagename}:latest ${dockerusername}/${imagename}:latest
                                docker image push ${dockerusername}/${imagename}:latest
                                docker image rm ${dockerusername}/${imagename}:latest ${imagename}:latest
                                exit
                            EOF
                        """
                    }
                }
            }
        }
    }
}
