pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'simple-node-app'
        SONARQUBE_SCANNER_HOME = tool 'Sonar'
        SLACK_CHANNEL = 'C07J983AQJV' //Slack channel ID
        SLACK_CREDENTIALS_ID = 'slack-creds'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/faisalmalik47/ScoreMe-Assessment.git'
            }
        }

        // stage('Build Docker Image') {
        //     steps {
        //         script {
        //             sh 'docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .'
        //             sh 'docker images'
        //             // sh ' yes | docker system prune -a'
        //         }
        //     }
        // }

        stage('Code Quality') {
            steps {
                script {
                    withSonarQubeEnv('Sonar') {
                        sh 'sonar-scanner -Dsonar.projectKey=ScoreMe-Assessment -Dsonar.sources=. -Dsonar.host.url=http://loalhost:9000 -Dsonar.token=sqp_563023edbe57e69b6500a416fbadd36ecd4757d8'
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
            slackSend channel: SLACK_CHANNEL, color: '#FFFF00', message: "Build #${env.BUILD_NUMBER} completed with status: ${currentBuild.currentResult}"
        }
        success {
            slackSend channel: SLACK_CHANNEL, color: '#00FF00', message: "Build #${env.BUILD_NUMBER} succeeded! 🎉"
        }
        failure {
            slackSend channel: SLACK_CHANNEL, color: '#FF0000', message: "Build #${env.BUILD_NUMBER} failed! :x:"
        }
    }
}
