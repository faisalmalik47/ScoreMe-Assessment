pipeline {
    agent any

    environment {
        SLACK_CHANNEL = 'C07J983AQJV' // Slack channel ID
        SLACK_CREDENTIALS_ID = 'slack-creds'
        SONARQUBE_SERVER = 'http://13.235.76.1:9000'
        SONARQUBE_TOKEN = 'squ_2cd5543f155dfc8c93c55ed94cc5ae6603564a6f'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/faisalmalik47/ScoreMe-Assessment.git'
            }
        }

        stage('Code Quality') {
            steps {
                script {
                    docker.image('sonarsource/sonar-scanner-cli:latest').inside {
                        sh """
                        sonar-scanner \
                          -Dsonar.projectKey=ScoreMe-Assessment \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=${SONARQUBE_SERVER} \
                          -Dsonar.token=${SONARQUBE_TOKEN}
                          -Dsonar.userHome=/tmp
                        """
                    }
                }
            }
        }

        stage('Code Coverage') {
            steps {
                echo 'No code coverage tool configured for Node.js'
            }
        }

        stage('Cyclomatic Complexity') {
            steps {
                script {
                    sh 'lizard -i -m 10'
                }
            }
        }

        stage('Security Vulnerability Scan') {
            steps {
                script {
                    sh 'dependency-check --project simple-node-app --scan .'
                }
            }
        }

        stage('NPM install') {
            steps {
                script {
                    sh 'cd /home/ubuntu/ScoreMe-Assessment && npm install'
                }
            }
        }

        stage('NPM Run Build') {
            steps {
                script {
                    sh 'cd /home/ubuntu/ScoreMe-Assessment && npm run build'
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploy step (can be customized based on your requirements)'
            }
        }
    }

    post {
        always {
            slackSend(channel: SLACK_CHANNEL, color: '#FFFF00', message: "Build #${env.BUILD_NUMBER} completed with status: ${currentBuild.currentResult}")
        }
        success {
            slackSend(channel: SLACK_CHANNEL, color: '#00FF00', message: "Build #${env.BUILD_NUMBER} succeeded! 🎉")
        }
        failure {
            slackSend(channel: SLACK_CHANNEL, color: '#FF0000', message: "Build #${env.BUILD_NUMBER} failed! :x:")
        }
    }
}
