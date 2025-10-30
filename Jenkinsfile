pipeline {
    agent { node 'jenkins-slave' }
    triggers {
        githubPush()
        pollSCM('H/5 * * * *')
    }
    
    environment {
        IMAGE_NAME = "demo-micro"  // nombre de imagen
        DOCKERHUB_NAMESPACE = "richardc7"  // usuario Docker Hub
        REGISTRY = "docker.io"
        K8S_NAMESPACE = 'demo'
        K8S_DEPLOYMENT = 'demo-micro'
        DEPLOY_BRANCH = 'reto-3/k8s'
    }
    
    options {
        timestamps()
        ansiColor('xterm')
        disableConcurrentBuilds()
    }
    
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Test') {
            steps { sh 'mvn -B test' }
            post { always { junit 'target/surefire-reports/*.xml' } }
        }

        stage('Build JAR') {
            steps { sh 'mvn -B -DskipTests clean package' }
            post { success { archiveArtifacts artifacts: 'target/*.jar', fingerprint: true } }
        }

        stage('Build & Push Image') {
            steps {
                script {
                    def tag = env.BUILD_NUMBER
                    def image = docker.build("${DOCKERHUB_NAMESPACE}/${IMAGE_NAME}:${tag}")
                    docker.withRegistry("https://index.docker.io/v1/", 'dockerhub-creds') {
                        image.push(tag)
                        image.push('latest')
                    }
                }
            }
        }

        stage('Deploy to k3s') {
            when {
                branch env.DEPLOY_BRANCH
                expression {
                    def relevant = false
                    for (cs in currentBuild.changeSets) {
                        for (item in cs.items) {
                            for (path in item.affectedFiles) {
                                if (path.path.startsWith('src/') || path.path == 'pom.xml' || path.path.startsWith('k8s/')) { relevant = true; break }
                            }
                        }
                    }
                    return relevant
                }
            }
            steps {
                sh '''
                kubectl apply -f k8s/namespace.yaml || true
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                kubectl -n ${K8S_NAMESPACE} set image deployment/${K8S_DEPLOYMENT} ${IMAGE_NAME}=docker.io/${DOCKERHUB_NAMESPACE}/${IMAGE_NAME}:${BUILD_NUMBER} --record
                kubectl -n ${K8S_NAMESPACE} rollout status deployment/${K8S_DEPLOYMENT}
                kubectl -n ${K8S_NAMESPACE} get pods
                '''
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