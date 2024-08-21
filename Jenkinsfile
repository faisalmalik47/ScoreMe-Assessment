pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'simple-node-app'
        SONARQUBE_SCANNER_HOME = tool 'SonarQube Scanner'
        SLACK_CHANNEL = '#your-channel'
        SLACK_CREDENTIALS_ID = 'your-slack-credentials-id'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/faisalmalik47/ScoreMe-Assessment.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Code Quality') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh 'sonar-scanner -Dsonar.projectKey=simple-node-app -Dsonar.sources=. -Dsonar.host.url=http://your-sonarqube-url -Dsonar.login=your-sonarqube-token'
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
