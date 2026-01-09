pipeline {
    agent any

    environment {
        IMAGE_NAME = "akashgoudru/backend-app"
        DOCKER_CREDS = "dockerhub-creds"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📥 Checking out source code from GitHub"
                git branch: 'main',
                    url: 'https://github.com/AkashBammannavar/capstoneDEVOPS.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building backend Docker image"
                bat 'docker build -t %IMAGE_NAME% backend'
            }
        }

        stage('Run Unit Tests (Health Check)') {
            steps {
                echo "🧪 Running backend container for testing"
                bat '''
                docker run -d -p 5000:5000 --name test_backend %IMAGE_NAME%
                timeout /t 8
                curl http://localhost:5000/health
                docker rm -f test_backend
                '''
            }
        }

        stage('Security Scan - Trivy') {
            steps {
                echo "🔐 Running Trivy security scan"
                bat 'docker run --rm aquasec/trivy image %IMAGE_NAME%'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo "🔑 Logging in to Docker Hub"
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo "📤 Pushing Docker image"
                bat 'docker push %IMAGE_NAME%'
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo "🚀 Deploying to staging environment"
                bat '''
                docker compose -f docker-compose.staging.yml pull
                docker compose -f docker-compose.staging.yml down
                docker compose -f docker-compose.staging.yml up -d
                '''
            }
        }

        stage('Run Database Migration') {
            steps {
                echo "🗄️ Running database migration"
                bat 'docker exec backend_staging python migrate.py'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "✅ Verifying deployment"
                bat '''
                timeout /t 10
                curl http://localhost:5001/health
                '''
            }
        }
    }

    post {
        success {
            echo "🎉 Jenkins CI/CD Pipeline completed successfully!"
        }
        failure {
            echo "❌ Jenkins CI/CD Pipeline failed. Check logs."
        }
    }
}
