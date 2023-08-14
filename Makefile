# export DOCKER_DEFAULT_PLATFORM=linux/amd64
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"

apply: up test	
	terraform apply -lock=false -var-file fixtures.tfvars -auto-approve -compact-warnings

up:
	#docker network create localstack || true
	docker-compose up -d # --pull always -d
	docker inspect localstack/localstack | jq '.[0].Architecture'

test:
	terraform fmt
	terraform init -backend=false -upgrade -lock=false
	terraform validate
	terraform plan -lock=false -input=false -var-file fixtures.tfvars
	terraform apply -input=true -auto-approve
	terraform state list
	aws --endpoint-url=http://localhost:4566 s3 ls

providers version show output:
	terraform $@

.PHONY: clean
clean:
	rm -rf .terraform
	rm -rf terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
	docker-compose down -v
