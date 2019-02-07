# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###
GCP PA Load Balancer

* Quick summary
* Version

### PA Firewall ###
1. Bootstrap with nat-web - nat traffic from untrust to web LB
2. nat-out - nat traffic from web instances to Internet 


### Internal Web instances ###
1. Startup script will run to install updates and nginx web server(http)
2. Delayed - will run startup script once firewall is up and ready.
3. No public IP address
4. Default route to PA trusted interface.

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact