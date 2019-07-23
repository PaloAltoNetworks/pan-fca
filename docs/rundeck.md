# Rundeck #
Rundeck is an operations management platform that helps you connect your people with the processes and tools they need to get their job done. The most common usage of Rundeck is to create standard operating procedures from any of your existing tools or scripts.

## Build the container ##
The container currently does not have a docker-hub ready image and the feature is not merged int the master pan-fca branch. You have to build it on your own after checking-out the rundeck branch. 
```
git clone https://github.com/PaloAltoNetworks/pan-fca.git
cd pan-fca
git checkout rundeck
docker build -t fca -f Dockerfile-Full .
```

## Run the container ##
The command needs to be run only once. The container will start automatically after the docker engine starts. 

Go to the pan-fca directory:

`cd pan-fca`

And run the container
```
docker run -p 4440:4440 -e EXTERNAL_SERVER_URL=http://localhost:4440 -v ${PWD}:/fca -v ${PWD}/projects:/var/rundeck/projects --name pan-fca -h pan-fca -t fca:latest &
```

The docker commands creates a docker container and does a port-forwarding to the pan-fca container that runs rundeck.

Expected behaviour:
```
docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                            NAMES
58618ee76259        fca:latest          "/opt/run"          3 hours ago         Up 3 hours          0.0.0.0:4440->4440/tcp, 4443/tcp                 pan-fca
```

Entering the container shell:

`docker exec -it pan-fca bash`

If you want to stop the docker container simply type:

`docker stop pan-fca`

If you want to delete the container:

`docker rm pan-fca`

## Accessing rundeck ##
After running the docker container, open your browser and go to http://localhost:4440. 

The rundeck user name and password are set to the default admin/admin. 

Please allow rundeck around 3mins to start.

## pan-fca and Rundeck ##
In order to use rundeck just create a project and deploy jobs in it. 
Currently some of the PAN cloud deployment scenarios are being moved to the rundeck gui. Please be patient.
