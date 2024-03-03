# Part 1: Application and Container Building
#### In this part, you will build two containers using Docker, one for the server and another for the client.
### [Server Build up](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/server/README.md):

For Building Up the Server I had written

1. [Dockerfile](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/server/Dockerfile), 
2. [Server.py](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/server/server.py) 
3. [requirements.txt](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/server/server.py)  and 
4. [Docker-compose](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/server/docker-compose) 

Which will be used will deploying the infra.

Composing docker Image and Pushing it to Docker Hub

### [Client Build up](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/README.md):

For Building Up the Server I had written

1. [Dockerfile](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/Dockerfile), 
2. [Server.py](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/server.py) 
3. [requirements.txt](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/client.py)  and 
4. [Docker-compose](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/docker-compose) 

---

# Part 2: Creating VMs, [Infra as a Code (IaC)](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Terraform/README.md)

### ***1.*** Prerequisites for run Infra as a Code (IaC)
### 2. Use Terraform for infrastructure automation. Place your Terraform scripts 
#### *To use this Terraform code [ec2-Provession.tf](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Terraform/ec2-Provession.tf), follow these steps:*

 **Step 1:** `terraform init`

 **Step 2:** `terraform Validate` 

 **Step 3:** `terraform plan` 

 **Step 4:** `terraform apply`

---

# Part 3: Setting up [Monitoring Stack]((https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Monitoring-Stack/README.md)) using Prometheus and Grafana:

### 1 Create a new directory called "Monitoring-Stack" 
### 2. For Essential Tools Installation  Refer to: [Essentials_Installation](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Monitoring-Stack/Essentials_Installation.sh)

### 3. While Setting up the Monitoring-Stack , we need to install Prometheus , Grafana and  Node Exporter. To achieve this, follow these steps :

   **_a.  Configure Grafana by [docker-compose.yaml](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/tree/main/Monitoring-Stack/grafana/docker-compose.yaml) in [Grafana folder](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/tree/main/Monitoring-Stack/grafana)_**

   **_b.  Configure Prometheus to scrape metrics [docker-compose.yaml](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/tree/main/Monitoring-Stack/prometheus/docker-compose.yaml)  and [prometheus.yaml](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/tree/main/Monitoring-Stack/prometheus) in [prometheus folder](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/tree/main/Monitoring-Stack/prometheus/prometheus.yaml)_**
   
   **_c.  Configure Node-Exporter_**

   ###  Repeat this Process for both Server and Client VMs

---
# Part 4: Setting up CI/CD Pipelines
1. Create two separate Git repositories for the server and client codebases, if not done already.
1. Set up CI/CD pipelines for both repositories to ensure the following:
1. Images are pushed to a public registry like Docker Hub.
1. Update the image tag in Docker Compose, pull the new image, and deploy it as part of the CD process.

**Here is GitHub Actions workflow for the both Repositories**

*[.github/workflows/cicd.yaml:](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/.github/workflows/CI-CD-Pipeline.yaml)*

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
![private Git runners](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Images/Repo-Secrets.png)
---
# Part 5: Documentation 

1. Include a README file in each repository with all the necessary information to set up the entire infrastructure and pipeline.
1. Document each step, including prerequisites, installation and configuration instructions,
usage examples, and troubleshooting tips.

## SERVER OUT PUT

**[GRAFANA](http://54.236.218.136:3000/)**

![GRAFANA](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Images/Server-Grafana.png)

**[PROMETHEUS](http://54.236.218.136:9090/graph)**

![PROMOTHEUS](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Images/Server-Prometheus.png)

**[SERVER](http://54.196.238.114:5000)**
**SERVER-IP 54.236.218.136**

## CLIENT OUT PUT

**[GRAFANA](http://54.196.238.114:3000/)**

![GRAFANA](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Images/Client-Grafana.png)

**[PROMETHEUS](http://54.196.238.114:9090/graph)**

![PROMOTHEUS](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/Images/Client-Prometheus.png)

**[CLIENT IP](http://54.196.238.114:8000)**
**CLIENT-IP 54.196.238.114**	
---
