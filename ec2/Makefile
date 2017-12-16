MAKEFLAGS += --silent

init:
	terraform init

plan: init
	terraform plan -var-file="config.tfvars" -var-file="credentials.tfvars"

apply: init
	terraform apply -var-file="config.tfvars" -var-file="credentials.tfvars"