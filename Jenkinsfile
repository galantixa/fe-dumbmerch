def branch = "production"
def repo = "git@github.com:galantixa/fe-dumbmerch.git"
def cred = "monitor"
def dir = "~/fe-dumbmerch"
def server = "appserver@103.139.193.35"
def imagename = "dumbmerch-fe-production"
def dockerusername = "galantixa"
def dockerpass = "dckr_pat_-uWxmibjWrkcl0syj8SQG2hOOJM"

pipeline {
    agent any
        post {
            always {
                discordSend description: 'Build Pipeline', footer: 'Galantixa DevOps', image: '', link: 'env.BUILD_URL', result: 'SUCCESS',scmWebUrl: '', thumbnail: '',
                title: 'env.JOB_NAME', webhookURL: 'https://discord.com/api/webhooks/1136155760070512710/HCt4LQL74vsufx7itH-tIz6JrsFVDqsuyUQzy7akT_pF4h_RKBJG7XcAJKeBiCKXOdWZ'
            }
        }
    stages {
        stage('Repo pull') {
            steps {
                script {
                    sshagent(credentials: [cred]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -T ${server} << EOF
                                rm -rf ${dir}
                                git clone ${repo}
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

