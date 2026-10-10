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
        stage('Check Docker'){
            steps {
                dir('jenkins-react-ci') {
                    sh 'docker --version'
                }        
            }
        }
        stage('Docker Build'){
            steps {
                dir('jenkins-react-ci') {
                    sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
                }        
            }
        }
        stage('Push Docker Image'){
            steps {
                dir('jenkins-react-ci') {
                    withCredentials([
                        strings(
                            credentialsID: 'Docker_Username',
                            variable: 'DOCKER_USER'
                        ),
                        strings(
                            credentialsID: 'Docker_Password',
                            variable: 'DOCKER_PASS'
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
    }

    post {
        success {
            echo "Greate our first ci pipelin is succeded"
        }
    }
}
