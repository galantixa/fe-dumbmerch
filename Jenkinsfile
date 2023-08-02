def branch = "staging"
def repo = "git@github.com:galantixa/fe-dumbmerch.git"
def cred = "monitor"
def dir = "~/fe-dumbmerch"
def server = "appserver@103.139.193.35"
def imagename = "dumbmerch-fe-production"
def dockerusername = "galantixa"
def dockerpass = "dckr_pat_-uWxmibjWrkcl0syj8SQG2hOOJM"

def sshAgentAndRun(def credentials, def script) {
    sshagent(credentials: [credentials]) {
        sh """
            ssh -o StrictHostKeyChecking=no -T ${server} << EOF
            ${script}
            exit
            EOF
        """
    }
}

pipeline {
    agent any

    stages {
        stage('Repo pull') {
            steps {
                script {
                    sshAgentAndRun(credentials: [cred], script: """
                        rm -rf ${dir}
                        git clone ${repo} || true
                        cd ${dir}
                        git checkout ${branch} || true
                        git pull origin ${branch} || true
                    """)
                }
            }
        }

        stage('Image build') {
            steps {
                script {
                    sshAgentAndRun(credentials: [cred], script: """
                        cd ${dir}
                        docker build -t ${imagename}:latest .
                    """)
                }
            }
        }

        stage('Running the image') {
            steps {
                script {
                    sshAgentAndRun(credentials: [cred], script: """
                        cd ${dir}
                        docker container stop ${imagename} || true
                        docker container rm ${imagename} || true
                        docker run -d -p 3001:3000 --restart=always --name="${imagename}" ${imagename}:latest
                    """)
                }
            }
        }
        
        stage('Image push') {
            steps {
                script {
                    sshAgentAndRun(credentials: [cred], script: """
                        docker login -u ${dockerusername} -p ${dockerpass}
                        docker image tag ${imagename}:latest ${dockerusername}/${imagename}:latest
                        docker image push ${dockerusername}/${imagename}:latest
                        docker image rm ${dockerusername}/${imagename}:latest
                    """)
                }
            }
        }
    }

    post {
        always {
            discordSend description: "Pipeline build",
                        footer: "Galantixa DevOps",
                        link: env.BUILD_URL,
                        result: currentBuild.resultIsBetterOrEqualTo('SUCCESS'),
                        title: JOB_NAME,
                        webhookURL: "https://discord.com/api/webhooks/1136155760070512710/HCt4LQL74vsufx7itH-tIz6JrsFVDqsuyUQzy7akT_pF4h_RKBJG7XcAJKeBiCKXOdWZ"
        }
    }
}
