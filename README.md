# Part 1: Application and Container Building
#### In this part, you will build two containers using Docker, one for the server and another for the client.
### Server:
1. Choose an appropriate base image from the Official Images list.
1. Create a Dockerfile for the server container with the following specifications:
1. Use a volume named "servervol" and mount it at "/serverdata" in the container.
1. Install necessary packages and dependencies required for your server application.
1. Write a server application in your preferred language that does the following:
1. Creates a 1KB file with random text data in the "/serverdata" directory.
1. Sends the file and its checksum to the client.
1. Use Docker Compose to define and run the server container.
### Client:
1.  Choose an appropriate base image from the Official Images list.
1.  Create a Dockerfile for the client container with the following specifications:
1.  Use a volume named "clientvol" and mount it at "/clientdata" in the container.
1.  Install necessary packages and dependencies required for your client application.
1.  Write a client application in your preferred language that does the following:
1.  Connects to the server and receives the file.
1.  Saves the received file in the "/clientdata" directory.
1.  Verifies the file's integrity by checking the received checksum.
1.  Use Docker Compose to define and run the client container.
#### Create two separate Git repositories to host the client and server codebases.
---

# Part 2: Creating VMs, Infra as a Code (IaC)

### ***1.*** Prerequisites for run Infra as a Code (IaC)
### 2. Use Terraform for infrastructure automation. Place your Terraform scripts 
#### *To use this Terraform code [main.tf](main.tf), follow these steps:*

 **Step 1:** `terraform init`

 **Step 2:** `terraform Validate` 

 **Step 3:** `terraform plan` 

 **Step 4:** `terraform apply`

---

# Part 3: Setting up Monitoring Stack using Prometheus and Grafana:

### 1 Create a new directory called "Monitoring-Stack" 
### 2. For Essential Tools Installation  Refer to: [Essentials_Installation](https://)
### 3. While Setting up the Monitoring-Stack , we need to install Prometheus , Grafana and  Node Exporter. To achieve this, follow these steps :

   **_a.  Configure Grafana by [docker-compose.yaml]() in [Grafana folder]()_**

   **_b.  Configure Prometheus to scrape metrics [docker-compose.yaml]()  and [prometheus.yaml]() in [prometheus folder]()_**
   
   **_c.  Configure Node-Exporter_**

   ###  Repeat this Process for both Server and Client VMs

---
# Part 4: Setting up CI/CD Pipelines
1. Create two separate Git repositories for the server and client codebases, if not done already.
1. Set up CI/CD pipelines for both repositories to ensure the following:
1. Images are pushed to a public registry like Docker Hub.
1. Update the image tag in Docker Compose, pull the new image, and deploy it as part of the CD process.

**Here is GitHub Actions workflow for the both Repositories**

*.github/workflows/cicd.yaml:*

```
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2
      with:
        fetch-depth: 0

    # Ensure Dockerfiles are present in client and server directories
    - name: Build and push Docker image for Client
      uses: docker/build-push-action@v2
      with:
        context: ./client/
        push: true
        tags: parshantjagwani/client:latest

    - name: Build and push Docker image for Server
      uses: docker/build-push-action@v2
      with:
        context: ./server/
        push: true
        tags: parshantjagwani/server:latest

    - name: Upload Docker Compose
      uses: actions/upload-artifact@v2
      with:
        name: docker-compose
        path: ./docker-compose.yml

  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2
      with:
        fetch-depth: 0

    - name: Download Docker Compose
      uses: actions/download-artifact@v2
      with:
        name: docker-compose
        path: ./docker-compose.yml

    - name: Update Docker Compose with latest images
      run: |
        sed -i 's|parshantjagwani/client:.*|parshantjagwani/client:latest|' docker-compose.yml
        sed -i 's|parshantjagwani/server:.*|parshantjagwani/server:latest|' docker-compose.yml

    # Configure EC2-VMs as private Git runners and use AWS credentials for deploying
    - name: Deploy to Client VM
      run: |
        aws configure set aws_access_key_id ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws configure set aws_secret_access_key ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws ssm send-command --document-name "AWS-RunShellScript" --instance-ids ${{ secrets.CLIENT_INSTANCE_ID }} $(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text) --commands "docker-compose up --build --remove-orphans"

    - name: Deploy to Server VM
      run: |
        aws configure set aws_access_key_id ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws configure set aws_secret_access_key ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws ssm send-command --document-name "AWS-RunShellScript" --instance-ids ${{ secrets.SERVER_INSTANCE_ID }} $(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text) --commands "docker-compose up --build --remove-orphans"

  notify:
    needs: deploy
    runs-on: ubuntu-latest

    steps:
    - name: Send deployment notification
      uses: rtCamp/action-slack-notify@v2
      with:
        payload: |
          {
            "text": "Server deployed successfully: ${{ github.run_id }}"
          }
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---
**Integrate a Slack webhook for deployment notifications.**
---
To integrate the Slack webhook, Follow Instructions from: [Slack_webhooks](https://github.com/orgs/community/discussions/70288#discussion-5745174ctions)

---
**Configure the corresponding VMs as private Git runners.**
---
---
# Part 5: Documentation 

1. Include a README file in each repository with all the necessary information to set up the entire infrastructure and pipeline.
1. Document each step, including prerequisites, installation and configuration instructions,
usage examples, and troubleshooting tips.
---
