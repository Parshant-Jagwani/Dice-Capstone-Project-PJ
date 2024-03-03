# Client Build up

### For Building Up the Server I had written 

#### 1. [Dockerfile](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/Dockerfile), 
#### 2. [Server.py](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/server.py) 
#### 3. [requirements.txt](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/client.py)  and 
#### 4. [Docker-compose](https://github.com/Parshant-Jagwani/Dice-Capstone-Project-PJ/blob/main/client/docker-compose) 

### Which will be used will deploying the infra.

# Composing docker Image and Pushing it to Docker Hub

#### FOR COMPOSE Locally: `docker-compose up  --name=client-serverapp-client -d`

#### FOR Pushing To Docker Hub:
```
docker login
docker tag client-serverapp-server:latest parshantjagwani/client-serverapp-client:latest
docker push parshantjagwani/client-serverapp-client:latest
```
