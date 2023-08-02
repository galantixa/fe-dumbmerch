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
                            ssh -o StrictHostKeyChecking=no -T ${server}
                        """
                    }
                }
            }
        }
    }
}
