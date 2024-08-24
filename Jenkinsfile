pipeline {
    agent any
        tools {
            jdk 'jdk17'
            nodejs 'node19'
        }

    environment {
        SLACK_CREDENTIALS_ID = 'slack-token'
        SONARQUBE_SERVER = 'http://65.1.94.192:9000'
        SCANNER_HOME = tool 'sonar-scanner'
        IMAGE_NAME = 'reddit'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        TRIVY_OUTPUT_FILE = "trivy-scan-${env.BUILD_NUMBER}.html"
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


        /*
        stage('Cyclomatic Complexity') {
            steps {
                script {
                    sh 'lizard -i -m 10'
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
        stage('Trivy Image Scan'){
            steps{
                script{
                    sh '''
                    sudo docker run aquasec/trivy image faisalmaliik/${IMAGE_NAME}:${IMAGE_TAG} > ${TRIVY_OUTPUT_FILE} 2>&1
                    '''
                }
            }
        }
        stage('Publish Trivy Scan Report') {
            steps {
                def trivyOutputFile = "trivy-scan-${env.BUILD_NUMBER}.html"
                publishHTML([
                    target: [
                        reportDir: '.',         
                        reportFiles: trivyOutputFile,  
                        keepAll: true,                
                        alwaysLinkToLastBuild: true,  
                        allowMissing: false  
                    ]
                ])
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
                    sh "docker run -d --name reddit-clone -p 80:5173 faisalmaliik/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

    }



    post {
        success {
            script {
                slackSend(color: 'good', message: "Deployment on ${env.JOB_NAME} succeeded! Build Number - ${env.BUILD_NUMBER}, New codebase is live now. Job built by ${env.BUILD_USER_NAME} , Job URL:  ${env.BUILD_URL}")
                def previousBuildFile = '/var/lib/jenkins/previous_successful_build.txt'
                def buildNumber = env.BUILD_NUMBER
                sh "echo ${buildNumber} > ${previousBuildFile}"
                sh "docker system prune -f"
            }
        }
        failure {
            script {
                slackSend(color: 'danger', message: "Deployment on ${env.JOB_NAME} Failed! Build Number - ${env.BUILD_NUMBER}, Reverted to Previous successfull build.  Job built by ${env.BUILD_USER_NAME} , Job URL:  ${env.BUILD_URL}")
                def previousBuildFile = '/var/lib/jenkins/previous_successful_build.txt'
                def previousBuildNumber = ''
                if (fileExists(previousBuildFile)) {
                // Read the previous build number from the file
                    previousBuildNumber = readFile(previousBuildFile).trim()
                    }
                if (previousBuildNumber) {
                    def imageTag = "${IMAGE_NAME}:${previousBuildNumber}"
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                        sh """
                            docker stop reddit-clone || true
                            docker rm reddit-clone || true
                        """
                        sh "docker run -d --name reddit-clone -p 80:5173 faisalmaliik/${imageTag}"
                    }
                }
                else {
                error "Previous successful build file not found or is empty. Cannot deploy."
            }
                sh "docker system prune -f"
            }
        }
    }
}
