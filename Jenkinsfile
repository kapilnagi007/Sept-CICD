pipeline {
    agent any

    environment {
        IMAGE_NAME = 'kopilnagi/jenkins-react-ci'
        IMAGE_TAG = '${BUILD_NUMBER}'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        // -----------Simple NPM CI Pipeline start
        // stage('Install Dependencies') {
        //     steps {
        //         sh 'node --version'
        //         sh 'npm --version'
        //         sh 'npm ci'
        //     }
        // }
        // stage('lint') {
        //     steps {
        //         sh 'npm run lint'
        //     }
        // }
        // stage('Unit Test') {
        //     steps {
        //         sh 'npm run test:ci'
        //     }
        // }
        // stage("Build") {
        //     steps {
        //         sh 'npm run build'
        //     }
        // }
        // ---------Simple NPM CI Pipeline start
        
        stage('SonarQube'){
            steps{
                withSonarQubeEnv('SonarQube')

            }
        }

        stage('Qulaty Gate'){
            steps{
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Check Docker'){
            steps {
                sh 'docker --version'    
            }
        }
        stage('Docker Build'){
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."   
            }
        }

        stage('Security Scan (Trivy Docker)') {
            steps {
                    echo "Running Trivy via Docker container..."
                    // Note: We mount the Docker socket so Trivy can inspect the built image,
                    // and mount a cache directory to avoid downloading the vulnerability DB every time.
                    sh """
                        docker run --rm \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        -v ${WORKSPACE}/.trivycache:/root/.cache/trivy \
                        aquasec/trivy:latest \
                        image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}
                    """
                }
            }
        }

        stage('Push Docker Image'){
            steps {
                withCredentials([
                        strings(
                            credentialsID: "Docker_Username",
                            variable: "DOCKER_USER"
                        ),
                        strings(
                            credentialsID: "Docker_Password",
                            variable: "DOCKER_PASS"
                        )

                        ]) {
                            sh '''
                                echo "$DOCKER_PASS" | docker login -u "DOCKER_USER" --password-stdin

                                docker push "${IMAGE_NAME}:${IMAGE_TAG}"
                                
                                docker logout
                            '''
                    }        
            }
        }
    }

    post {
        success {
            echo "Greate our first ci pipelin is succeded"
        }
    }
}
