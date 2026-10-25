pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        // Stage for Terraform Initialization

        stage('Terraform Initialization') {
            steps {
                dir('Terraform') {
                    echo 'Initializing Terraform...'
                    sh 'terraform init'
                }
            }
        }

        // Stage for Terraform format and validation
        stage('Terraform Format and Validation') {
            steps {
                dir('Terraform/') {
                    echo 'Checking Terraform format...'
                    sh 'terraform fmt'
                    echo 'Validating Terraform configuration...'
                    sh 'terraform validate'
                }
            }
        }

        // Stage for Terraform Plan
        stage('Terraform Plan') {
            steps {
                dir('Terraform/') {
                    echo 'Creating Terraform plan...'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        // Stage for Terraform Apply
        stage('Terraform Apply') {
            steps {
                dir('Terraform/') {
                    echo 'Applying Terraform plan...'
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
