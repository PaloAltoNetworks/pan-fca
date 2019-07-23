* Rundeck * 


* Build the container *
The container currently does not have a docker hub ready image. You have to build it on your own. 

`git clone` 
`cd pan-fca`
`docker build -t fca -f Dockerfile-Full .`
`docker run -p 4440:4440 -e EXTERNAL_SERVER_URL=http://localhost:4440 -v ${PWD}:/fca -v ${PWD}/projects:/var/rundeck/projects --name pan-fca -h pan-fca -t fca:latest`
