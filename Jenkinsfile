pipeline {
    agent { node 'jenkins-slave' }
    
    environment {
        IMAGE_NAME = "demo-micro"
        DOCKERHUB_NAMESPACE = "tu-usuario"  // Cambiar por tu usuario de Docker Hub
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
                    docker.withRegistry("https://${REGISTRY}", 'dockerhub-creds') {
                        image.push()
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