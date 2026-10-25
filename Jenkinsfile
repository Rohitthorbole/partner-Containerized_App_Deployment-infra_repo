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
                script {
            dir('Terraform') {
                echo 'Checking Terraform working directory...'
                sh '''
                    pwd
                    echo "Files in current directory:"
                    ls -la
                    echo "Terraform files:"
                    find . -maxdepth 3 -type f
                '''

                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
            }
        }

        // Stage for Terraform format and validation
        stage('Terraform Format and Validation') {
            steps {
                script {
                    dir('Terraform/') {
                        echo 'Checking Terraform format...'
                        sh 'terraform fmt -check'
                        echo 'Validating Terraform configuration...'
                        sh 'terraform validate'
                    }
                }
            }
        }

        // Stage for Terraform Plan
        stage('Terraform Plan') {
            steps {
                script {
                    dir('Terraform/') {
                        echo 'Creating Terraform plan...'
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        // Stage for Terraform Apply
        stage('Terraform Apply') {
            steps {
                script {
                    dir('Terraform/') {
                        echo 'Applying Terraform plan...'
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }
}
