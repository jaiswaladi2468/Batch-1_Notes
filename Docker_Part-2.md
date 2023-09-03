Docker provides a flexible networking system that allows containers to communicate with each other and with the outside world. You can create and manage Docker networks using the Docker CLI. Here are some basic Docker network commands with examples:

1. **List Docker Networks:**
   To see a list of all available Docker networks, use the `docker network ls` command.

   ```bash
   docker network ls
   ```

2. **Create a Custom Bridge Network:**
   You can create a custom bridge network to isolate containers from the host network. This is useful when you want containers to communicate with each other privately.

   ```bash
   docker network create my_custom_network
   ```

3. **Create a Container on a Specific Network:**
   When running a container, you can specify the network it should connect to using the `--network` flag.

   ```bash
   docker run --name container1 --network my_custom_network -d nginx
   ```

4. **Inspect Network Details:**
   To view details about a specific network, use the `docker network inspect` command.

   ```bash
   docker network inspect my_custom_network
   ```

5. **Create a Container with a Specific IP Address:**
   You can specify a static IP address for a container within a custom bridge network using the `--ip` flag.

   ```bash
   docker run --name container2 --network my_custom_network --ip 172.18.0.10 -d nginx
   ```

6. **Connect an Existing Container to a Network:**
   You can also connect an existing container to a network using the `docker network connect` command.

   ```bash
   docker network connect my_custom_network container1
   ```

7. **Disconnect a Container from a Network:**
   To disconnect a container from a network, use the `docker network disconnect` command.

   ```bash
   docker network disconnect my_custom_network container1
   ```

8. **Remove a Custom Network:**
   To remove a custom network, use the `docker network rm` command. Make sure no containers are using the network before removing it.

   ```bash
   docker network rm my_custom_network
   ```

These are some common Docker networking commands and examples. Docker provides various network drivers, such as bridge, host, overlay, and macvlan, which offer different networking capabilities. Choose the appropriate network driver based on your use case and requirements.

# Docker-Compose

Docker Compose is a tool for defining and running multi-container Docker applications. It allows you to define your application's services, networks, and volumes in a single `docker-compose.yml` file, making it easier to manage complex Docker setups. Here's a guide on how to use Docker Compose with examples:

### Install Docker Compose
Before you begin, make sure you have Docker Compose installed. You can download it from the [official Docker Compose website](https://docs.docker.com/compose/install/).

### Creating a Docker Compose File
Create a `docker-compose.yml` file in your project directory. This file will define your Docker services and their configurations.

Here's a simple example that defines two services, a web application using Nginx and a backend using Node.js:

```yaml
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
  backend:
    image: node:14
    working_dir: /app
    volumes:
      - ./backend:/app
    command: npm start
```

In this example:

- `version: '3'` specifies the Docker Compose file version.
- `services` section defines two services: `web` and `backend`.
- `web` uses the official Nginx image and maps port 80 of the host to port 80 of the container.
- `backend` uses the official Node.js image, sets a working directory, mounts a local directory as a volume, and specifies a command to run when the container starts.

### Docker Compose Commands
Here are some common Docker Compose commands you can use:

1. **Start Containers:** Start your services defined in the `docker-compose.yml` file.

   ```bash
   docker-compose up
   ```

   Add the `-d` flag to run in detached mode (in the background).

   ```bash
   docker-compose up -d
   ```

2. **Stop Containers:** Stop the containers defined in the `docker-compose.yml` file.

   ```bash
   docker-compose down
   ```

3. **View Logs:** View the logs of your running containers.

   ```bash
   docker-compose logs
   ```

4. **Build Services:** Build or rebuild services (useful when you make changes to your Dockerfile or source code).

   ```bash
   docker-compose build
   ```

5. **Scale Services:** You can scale services by specifying the desired number of replicas. For example, to run two instances of the `backend` service:

   ```bash
   docker-compose up -d --scale backend=2
   ```

6. **Execute a Command in a Service:** You can execute commands within a specific service using `docker-compose exec`. For example, to run a shell in the `backend` service:

   ```bash
   docker-compose exec backend sh
   ```

### Cleaning Up
To remove all containers and networks created by Docker Compose, use:

```bash
docker-compose down --volumes
```

This will also remove the volumes associated with your services.

These are some of the basic Docker Compose commands and examples to get you started. Docker Compose is a powerful tool for managing containerized applications, and you can define more complex configurations and dependencies in your `docker-compose.yml` file as your project evolves.

## SAMPLE


```bash
# Start MongoDB container
docker run -d \
-p 27017:27017 \
-e MONGO_INITDB_ROOT_USERNAME=rootuser \
-e MONGO_INITDB_ROOT_PASSWORD=rootpass \
--name mongodb \
--net mongo-network \
mongo

# Start Mongo Express container
docker run -d \
-p 8081:8081 \
-e ME_CONFIG_MONGODB_ADMINUSERNAME=rootuser \
-e ME_CONFIG_MONGODB_ADMINPASSWORD=rootpass \
-e ME_CONFIG_MONGODB_SERVER=mongodb \
--name mongo-express \
--net mongo-network \
mongo-express
```



### Here's the equivalent Docker Compose file for your setup

```yaml
version: '3.5'
services:
  mongodb:
    image: mongo
    container_name: mongodb
    ports:
      - 27017:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=rootuser
      - MONGO_INITDB_ROOT_PASSWORD=rootpass
    networks:
      - mongo-network

  mongo-express:
    image: mongo-express
    container_name: mongo-express
    ports:
      - 8081:8081
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=rootuser
      - ME_CONFIG_MONGODB_ADMINPASSWORD=rootpass
      - ME_CONFIG_MONGODB_SERVER=mongodb
    restart: unless-stopped
    depends_on:
      - mongodb
    networks:
      - mongo-network

networks:
  mongo-network:
    name: mongo-network
```

This Docker Compose file defines two services, `mongodb` and `mongo-express`, just like your original Docker commands. It also specifies the necessary environment variables, ports, and network configurations. To use it, create a `docker-compose.yml` file in your project directory and run `docker-compose up -d` to start the services.
