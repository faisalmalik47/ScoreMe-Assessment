pipeline {
    agent any

    environment {
        SLACK_CHANNEL = 'C07J983AQJV' // Slack channel ID
        SLACK_CREDENTIALS_ID = 'slack-creds'
        SONARQUBE_SERVER = 'http://35.154.211.81:9000'
        CODE_BASE = '/home/ubuntu/ScoreMe-Assessment'
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
                    withCredentials([string(credentialsId: 'SONARQUBE_TOKEN', variable: 'SONARQUBE_TOKEN')]) {
                        sh """
                        docker run --rm -v \$(pwd):/usr/src --network=host sonarsource/sonar-scanner-cli:latest sonar-scanner \\
                            -Dsonar.projectKey=ScoreMe-Assessment \\
                            -Dsonar.sources=/usr/src \\
                            -Dsonar.host.url=${SONARQUBE_SERVER} \\
                            -Dsonar.token=${SONARQUBE_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Run Complexity Analysis') {
            steps {
                sh 'npm run plato'
            }
        }
        stage('Archive Reports') {
            steps {
                archiveArtifacts artifacts: 'plato-report/**/*', allowEmptyArchive: true
            }
        }

        // stage('Cyclomatic Complexity') {
        //     steps {
        //         script {
        //             sh 'lizard -i -m 10'
        //         }
        //     }
        // }

        // stage('Security Vulnerability Scan') {
        //     steps {
        //         script {
        //             sh 'dependency-check --project simple-node-app --scan .'
        //         }
        //     }
        // }

        // stage('NPM install') {
        //     steps {
        //         script {
        //             sh "cd ${CODE_BASE} && npm install"
        //         }
        //     }
        // }

        // stage('NPM Run Build') {
        //     steps {
        //         script {
        //             sh "cd ${CODE_BASE} && npm run build"
        //         }
        //     }
        // }

        // stage('Deploy') {
        //     steps {
        //         script {
        //             sh "cp -rf ${CODE_BASE}/build/* /var/www/html/"
        //         }
        //     }
        // }
    }

    // post {
    //     always {
    //         slackSend(channel: SLACK_CHANNEL, color: '#FFFF00', message: "Build #${env.BUILD_NUMBER} completed with status: ${currentBuild.currentResult}")
    //     }
    //     success {
    //         slackSend(channel: SLACK_CHANNEL, color: '#00FF00', message: "Build #${env.BUILD_NUMBER} succeeded! 🎉")
    //     }
    //     failure {
    //         slackSend(channel: SLACK_CHANNEL, color: '#FF0000', message: "Build #${env.BUILD_NUMBER} failed! :x:")
    //     }
    // }
}
