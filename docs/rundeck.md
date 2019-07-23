# Rundeck #
Rundeck is an operations management platform that helps you connect your people with the processes and tools they need to get their job done. The most common usage of Rundeck is to create standard operating procedures from any of your existing tools or scripts.

## Build the container ##
The container currently does not have a docker hub ready image. You have to build it on your own. 

`git clone` 

`cd pan-fca`

`docker build -t fca -f Dockerfile-Full .`


## Run the container ##
The command needs to be run only once. The container will start automatically after the docker engine starts. 

`docker run -p 4440:4440 -e EXTERNAL_SERVER_URL=http://localhost:4440 -v ${PWD}:/fca -v ${PWD}/projects:/var/rundeck/projects --name pan-fca -h pan-fca -t fca:latest`

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
