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

        // stage('Code Quality') {
        //     steps {
        //         script {
        //             withCredentials([string(credentialsId: 'SONARQUBE_TOKEN', variable: 'SONARQUBE_TOKEN')]) {
        //                 sh """
        //                 docker run --rm -v \$(pwd):/usr/src --network=host sonarsource/sonar-scanner-cli:latest sonar-scanner \\
        //                     -Dsonar.projectKey=ScoreMe-Assessment \\
        //                     -Dsonar.sources=/usr/src \\
        //                     -Dsonar.host.url=${SONARQUBE_SERVER} \\
        //                     -Dsonar.token=${SONARQUBE_TOKEN}
        //                 """
        //             }
        //         }
        //     }
        // }
        
        stage('NPM install') {
            steps {
                script {
                    sh "npm install"
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

        stage('Publish Test Report') {
            steps {
                writeFile file: 'test-report/index.html', text: '<html><body><h1>Test Report</h1></body></html>'
                publishHTML(target: [
                    reportDir: 'test-report',  // Directory where HTML files are located
                    reportFiles: 'index.html',      // Main HTML file to be displayed
                    keepAll: true,                  // Keep all reports
                    alwaysLinkToLastBuild: true,    // Link to the latest build's report
                    allowMissing: false             // Fail if report is missing
                ])
            }
        }
            

        // Uncomment the stages below if needed
        /*
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

        stage('NPM Run Build') {
            steps {
                script {
                    sh "cd ${CODE_BASE} && npm run build"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh "cp -rf ${CODE_BASE}/build/* /var/www/html/"
                }
            }
        }
        */
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