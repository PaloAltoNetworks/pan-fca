.DEFAULT_GOAL := help
.PHONY: help cloud aws azure destroy runner slim-runner

aws:
	ansible-playbook configuration_push.yml -e cloud_provider=aws

azure:
	ansible-playbook configuration_push.yml -e cloud_provider=azure

runner:
	docker run -it -v ${PWD}:/fca dirtyonekanobi/ansible-terraform

slim-runner:
	docker run -it -v ${PWD}:/fca dirtyonekanobi/ansible-terraform-slim

cloud:
	ansible-playbook configuration_push.yml
help:
	ansible --version

destroy:
	terraform destroy -auto-approve
