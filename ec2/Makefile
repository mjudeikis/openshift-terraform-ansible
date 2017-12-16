MAKEFLAGS += --silent

plan:
	terraform plan -var-file="config.tfvars" -var-file="credentials.tfvars"

apply:
	terraform apply -var-file="config.tfvars" -var-file="credentials.tfvars"