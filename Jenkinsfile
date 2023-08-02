def branch = "staging"
def repo = "git@github.com:galantixa/fe-dumbmerch.git"
def cred = "monitor"
def dir = "~/fe-dumbmerch"
def server = "appserver@103.139.193.35"
def imagename = "dumbmerch-fe"
def dockerusername = "galantixa"
def dockerpass = "dckr_pat_-uWxmibjWrkcl0syj8SQG2hOOJM"

pipeline {
    agent any
    stages {
        stage('Repo pull') {
            steps {
                script {
                    sshagent(credentials: [cred]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -T ${server}ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDR78xRNS//nALh+e7CN40TmWTL4G2931UcmYs3wLSSNExVWFXcpLtidWiS7KNE5xwOvU0nKvRb248ls02McFNkq3ibQTyrsRL4cjg4dxHkqMQojePoCzTi9+3mH1zUFiXhfHDCVJxekZn8JndW6pxKNn+6Wx8jU7AIBUNfLWD37yg6CdiBXDyvJ3jZfNDPwcbzUH/4sqtATLE5xKfUeUZnbwM8PPVsPACcV/FOXXWwnX+eY7a93Pyz3mBZ+rNs98mBwcjqnuWr1++udax7HThmaJbDzZVDXN/gWtxaMQBF3F2vJoQulvm7qbKzHOFXp0U4y48p78VsFQExOryDrCqTMRpAcFjavk59xibDJvTxAxqvMRMGdIcFz7+Xm16lj/ryOLdeiZ0n2HmdhqlTDzQWCFWP64eIXHHdE4Saiw0GXwGEUbEJ9rUNaJleVlAaQ8Ee6c9JzUs4BMQNw600e/jlYOrhXLvw007VaQvg5Q2pZo/Tuis//gXx16fhszQ/BQE= appserver@galantixa-app
			 << EOF
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
                    sshagent(credentials: [cred]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -T ${server} << EOF
                                cd ${dir}
                                docker build -t ${imagename}:latest .
                                exit
                            EOF
                        """
                    }
                }
            }
        }

        stage('Running the image') {
            steps {
                script {
                    sshagent(credentials: [cred]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -T ${server} << EOF
                                cd ${dir}
                                docker container stop ${imagename}
                                docker container rm ${imagename}
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
                    sshagent(credentials: [cred]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -T ${server} << EOF
                                docker login -u ${dockerusername} -p ${dockerpass}
                                docker image tag ${imagename}:latest ${dockerusername}/${imagename}:latest
                                docker image push ${dockerusername}/${imagename}:latest
                                docker image rm ${dockerusername}/${imagename}:latest
                                exit
                            EOF
                        """
                    }
                }
            }
        }
    }
}
