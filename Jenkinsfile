pipeline {
    agent any
        tools {
            jdk 'jdk17'
            nodejs 'node19'
        }

    environment {
        SLACK_CHANNEL = 'C07J983AQJV' // Slack channel ID
        SLACK_CREDENTIALS_ID = 'slack-creds'
        SONARQUBE_SERVER = 'http://65.1.94.192:9000'
        SCANNER_HOME = tool 'sonar-scanner'
        IMAGE_NAME = 'reddit'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {

         stage('Clean Workspace') {
            steps {
                cleanWs() 
            }
        }       
        stage('Checkout') {
            steps {
                git 'https://github.com/faisalmalik47/ScoreMe-Assessment.git'
            }
        }

        stage('Code Quality') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'Sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh """
                        docker run --rm -v \$(pwd):/usr/src --network=host sonarsource/sonar-scanner-cli:latest sonar-scanner \\
                            -Dsonar.projectKey=ScoreMeAssessment \\
                            -Dsonar.sources=/usr/src \\
                            -Dsonar.host.url=${SONARQUBE_SERVER} \\
                            -Dsonar.token=${SONAR_TOKEN}
                        """
                    }
                }
            }
        }

        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Checker'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        // stage('Install Dependencies') {
        //     steps {
        //         script {
        //             sh 'npm install'
        //         }
        //     }
        // }       

        // stage('Run Complexity Analysis') {
        //     steps {
        //         sh 'npm run plato'
        //     }
        // }

        // stage('Archive Reports') {
        //     steps {
        //         archiveArtifacts artifacts: 'plato-report/**/*', allowEmptyArchive: true
        //     }
        // }

        // stage('Publish Test Report') {
        //     steps {
        //         writeFile file: 'test-report/index.html', text: '<html><body><h1>Test Report</h1></body></html>'
        //         publishHTML(target: [
        //             reportDir: 'test-report',  // Directory where HTML files are located
        //             reportFiles: 'index.html',      // Main HTML file to be displayed
        //             keepAll: true,                  // Keep all reports
        //             alwaysLinkToLastBuild: true,    // Link to the latest build's report
        //             allowMissing: false             // Fail if report is missing
        //         ])
        //     }
        // }
        // stage('Allure Report') {
        //     steps {
        //         allure includeProperties: false, results: [[path: 'test-report']]
        //     }
        // }

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
        
        stage('Docker Build') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {   
                        // Build, tag, and push the Docker image
                        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                        sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} faisalmaliik/${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker push faisalmaliik/${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
        stage('Push Image to Registry'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker push faisalmaliik/${IMAGE_NAME}:${IMAGE_TAG}"
                }
                }
            }
        }

        stage('Deploy to container') {
            steps {
                script {
                    // Stop and remove any existing container with the same name
                    sh """
                        docker stop reddit-clone || true
                        docker rm reddit-clone || true
                    """
                    
                    // Run the Docker container using the same image name and tag
                    sh "docker run -d --name reddit-clone -p 80:3000 faisalmaliik/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

    }


    /*
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
    */
}
