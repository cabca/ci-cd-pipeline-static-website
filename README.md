
# CI/CD pipeline for static website with Jenkins, Terraform, Ansible, AWS and Docker.


### Step 1: Set Up Your Environment
1. GitHub Repository: Ensure your static website is hosted on a GitHub repository.
2. Jenkins Server: Set up a Jenkins server. You can use AWS EC2 for hosting Jenkins.
3. AWS Account: You need an AWS account to host your static website.
4. Terraform: Install Terraform to manage AWS infrastructure.
5. Ansible: Install Ansible for configuration management.
6. Docker: Install Docker to containerize your application.


### Step 2: Configure Jenkins
1. Install Plugins: Ensure the following plugins are installed on your Jenkins server:
   - GitHub Integration
   - Docker Pipeline
   - Terraform
   - Ansible
2. Create a Jenkins Pipeline: Create a new Jenkins pipeline job.


### Step 3: Define the Pipeline Script
Create a Jenkinsfile in the root of your GitHub repository. This file defines the steps Jenkins will take to build, test, and deploy your application.

Example Jenkinsfile:
```
pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('your-docker-image:latest')
                }
            }
        }

        stage('Run Terraform') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -auto-approve
                '''
            }
        }

        stage('Run Ansible') {
            steps {
                sh '''
                ansible-playbook -i ansible/hosts ansible/deploy.yml
                '''
            }
        }

        stage('Deploy to S3') {
            steps {
                sh '''
                aws s3 sync ./your-static-site s3://your-s3-bucket-name
                '''
            }
        }
    }
}
```


### Step 4: Configure Terraform
Create a terraform directory in your repository with the necessary Terraform configuration files to set up AWS resources.

Example main.tf:
```
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "your-s3-bucket-name"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.static_site_bucket.bucket
}
```


### Step 5: Configure Ansible
Create an ansible directory in your repository with the necessary Ansible playbooks to configure your environment.

Example hosts file:
```
[web]
your-ec2-instance-public-dns
```

Example deploy.yml:
```
- hosts: web
  become: yes
  tasks:
    - name: Install Docker
      apt:
        name: docker.io
        state: present
        update_cache: yes

    - name: Run Docker Container
      docker_container:
        name: static_site
        image: your-docker-image:latest
        state: started
        ports:
          - "80:80"
```


### Step 6: Configure AWS Credentials in Jenkins
1. Go to Jenkins Dashboard > Manage Jenkins > Manage Credentials.
2. Add AWS credentials (AWS Access Key ID and Secret Access Key) with IDs aws-access-key-id and aws-secret-access-key.


### Step 7: Trigger Jenkins on GitHub Push
1. Install the GitHub plugin in Jenkins if not already installed.
2. Configure your GitHub repository to send webhooks to your Jenkins server.
   - Go to your GitHub repo > Settings > Webhooks > Add webhook.
   - Payload URL: http://your-jenkins-server/github-webhook/
   - Content type: application/json
   - Select the "Just the push event" option.


### Step 8: Test the Pipeline
1. Make a change to your repository and push it to GitHub.
2. The Jenkins pipeline should trigger automatically and go through the stages of building the Docker image, applying Terraform configurations, running Ansible playbooks, and deploying the static site to the S3 bucket.

By following these steps, you can set up a robust CI/CD pipeline for your static website using Jenkins, Terraform, Ansible, AWS, and Docker.