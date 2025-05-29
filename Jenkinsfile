pipeline {
  agent any

  environment {
    DOCKER_USER = 'mayura1994'
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

    stage('Create MongoDB Secret & ConfigMap') {
      steps {
        sh '''
          # Create secret (ignore error if already exists)
          kubectl delete secret mongo-secret --ignore-not-found
          kubectl create secret generic mongo-secret \
            --from-literal=mongo-root-username=admin \
            --from-literal=mongo-root-password=password123 \
            --from-literal=mongo-app-username=calcuser \
            --from-literal=mongo-app-password=calcpass123

          # Create configmap from file (ensure mongo-init.js exists)
          kubectl delete configmap mongo-init-script --ignore-not-found
          kubectl create configmap mongo-init-script --from-file=mongo-init.js
        '''
      }
    }

    stage('Deploy MongoDB and App to K8s') {
      steps {
        sh '''
          kubectl apply -f mongo-pv.yaml
          kubectl apply -f mongo-pvc.yaml
          kubectl apply -f mongo-deployment.yaml
          kubectl apply -f mongo-service.yaml
          kubectl apply -f calculator-deployment.yaml
          kubectl apply -f calculator-service.yaml
        '''
      }
    }

    stage('Check Deployment') {
      steps {
        sh '''
          kubectl get pods
          kubectl get svc
        '''
      }
    }
  }
}
