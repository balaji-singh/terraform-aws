.PHONY: init plan apply destroy fmt validate docs test security-scan clean

# Variables
ENV ?= dev
COMPONENT ?= all

# Terragrunt commands
init:
	cd env/$(ENV) && terragrunt run-all init

plan:
	cd env/$(ENV) && terragrunt run-all plan

apply:
	cd env/$(ENV) && terragrunt run-all apply

destroy:
	cd env/$(ENV) && terragrunt run-all destroy

# Development commands
fmt:
	terraform fmt -recursive
	terragrunt hclfmt

validate:
	cd env/$(ENV) && terragrunt run-all validate

docs:
	terraform-docs markdown table --output-file README.md --output-mode inject ./modules/*

test:
	cd test && go test -v ./...

security-scan:
	tfsec .
	checkov --directory .
	terrascan scan -i terraform

clean:
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -type d -name ".terragrunt-cache" -exec rm -rf {} +
	find . -type f -name "terraform.tfstate*" -exec rm -f {} +
	find . -type f -name ".terraform.lock.hcl" -exec rm -f {} +

# Helper commands
list-workspaces:
	@cd env/$(ENV) && terragrunt run-all workspace list

cost-estimate:
	@cd env/$(ENV) && terragrunt run-all plan -out=plan.tfplan
	@cd env/$(ENV) && infracost breakdown --path plan.tfplan

init-all: init fmt validate docs
