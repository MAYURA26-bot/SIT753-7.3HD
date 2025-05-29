pipeline {
  agent any

  environment {
    DOCKER_USER = 'your-dockerhub-username'
    IMAGE_NAME = 'calculator-microservice'
  }

  stages {

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $DOCKER_USER/$IMAGE_NAME:latest .'
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh '''
            echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin
            docker push $DOCKER_USER/$IMAGE_NAME:latest
          '''
        }
      }
    }

    stage('Deploy MongoDB and App to K8s') {
      steps {
        sh '''
          kubectl apply -f mongo-secret.yaml ---
          kubectl apply -f mongo-pv.yaml
          kubectl apply -f mongo-pvc.yaml
          kubectl apply -f mongo-init-configmap.yaml --
          kubectl apply -f mongo-deployment.yaml
          kubectl apply -f mongo-service.yaml
          kubectl apply -f calculator-deployment.yaml
          kubectl apply -f calculator-service.yaml
        '''
      }
    }

    stage('Check Pods') {
      steps {
        sh 'kubectl get pods'
      }
    }
  }
}
