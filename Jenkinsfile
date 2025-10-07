pipeline {
    agent { node 'jenkins-slave' }
    
    environment {
        IMAGE_NAME = "demo-micro"  // Tu repositorio de docker hub
        DOCKERHUB_NAMESPACE = "richardc7"  // tu usuario de Docker Hub
        REGISTRY = "docker.io"
    }
    
    options {
        timestamps()
        ansiColor('xterm')
        disableConcurrentBuilds()
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build JAR') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
        
        stage('Build & Push Image') {
            steps {
                script {
                    def tag = env.BUILD_NUMBER
                    def image = docker.build("${DOCKERHUB_NAMESPACE}/${IMAGE_NAME}:${tag}")
                    
                    // Use Docker Hub registry with proper credentials
                    docker.withRegistry("https://index.docker.io/v1/", 'dockerhub-creds') {
                        image.push(tag)
                        image.push('latest')
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "Imagen publicada: ${env.REGISTRY}/${DOCKERHUB_NAMESPACE}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
        }
        failure {
            echo "Build fallido. Revisar logs."
        }
    }
}