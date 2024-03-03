# Part 3: Setting up Monitoring Stack using Prometheus and Grafana:

### 1. For Essential Tools Installation  Refer to: [Essentials_Installation](https://)

**Step 1: To Run  the `Essentials_Installation`, Execute Following Commands:
```
Sudo mkdir Scripts
mkdir Scripts
ls -a
cd ./Scripts
sudo nano Essentials_Installation.sh
cd /home/ec2-user/
ls
sudo chmod +x ./Scripts/Essentials_Installation.sh
./Scripts/Essentials_Installation.sh
```
NOTE: you have to clone  this `Essentials_Installation.sh` into your EC2 instance for running above `sudo nano Essentials_Installation.sh`  

---

### 2. While Setting up the Monitoring-Stack , we need to install Prometheus , Grafana and  Node Exporter. To achieve this, follow these steps :

_Monitoring-Stack Repo will be clone from above Script_
 
  #### a.  Configure Grafana by [docker-compose.yaml]() in [Grafana folder]()

  ```
  # composing up Grafana Container
  ls
  cd ./Monitoring-Stack/grafana
  nano docker-compose.yaml
  ls
  sudo docker-compose up -d
  sudo docker ps
  ```
   
  #### b.  Configure Prometheus to scrape metrics [docker-compose.yaml]()  and [prometheus.yaml]() in [prometheus folder]()
  
  ```
  # composing up Prometheus Container
  cd /home/ec2-user/Monitoring-Stack/prometheus
  ls
  nano docker-compose.yaml
  sudo docker-compose up -d
  sudo docker ps
  ```
  #### c.  Configure Node-Exporter

  ```
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
  ```
  _Copy below code in `sudo nano /etc/systemd/system/node_exporter.service` then CTRL+O , ENTER, CTRL+X_
  
  ```
    #script-node_exporter.service
    [Unit]
    Description=Node Exporter
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=node_exporter
    Group=node_exporter
    Type=simple
    ExecStart=/usr/local/bin/node_exporter
    Restart=always
    RestartSec=3

    [Install]
    WantedBy=multi-user.target
``` 
_Then  run commands to daemon-reload, enable and start node_exporter_

```
    sudo systemctl daemon-reload
    sudo systemctl enable node_exporter
    sudo systemctl start node_exporter
```
###  Repeat this Process for both Server and Client VMs
---
## Monitoring-Stack is Up and Running on:
