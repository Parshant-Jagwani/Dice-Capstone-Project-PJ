# Installation Script 
    # This is linked to Installations of Docker, Docker-Compose, 
    # Git, and importing git Repo and show outputs
Sudo mkdir Scripts
mkdir Scripts
ls -a
cd ./Scripts
sudo nano installation.sh
cd /home/ec2-user/
ls
sudo chmod +x ./Scripts/installation.sh
./Scripts/installation.sh

# composing up Grafana Container
ls
cd ./Monitoring-Stack/grafana
nano docker-compose.yaml
ls
sudo docker-compose up -d
sudo docker ps

# composing up Prometheus Container
cd /home/ec2-user/Monitoring-Stack/prometheus
ls
nano docker-compose.yaml
sudo docker-compose up -d
sudo docker ps

# Installing up Node-Exporter
cd /home/ec2-user/
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xvf node_exporter-1.7.0.linux-amd64.tar.gz
ls
cd node_exporter-1.7.0.linux-amd64
sudo cp node_exporter /usr/local/bin
ls
sudo useradd --no-create-home --shell /bin/false node_exporter
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo nano /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Cleaning-up 
cd /home/ec2-user/
ls
rm -rf ./node_exporter-1.7.0.linux-amd64.tar.gz

# Docker Running Containers:
sudo docker ps
