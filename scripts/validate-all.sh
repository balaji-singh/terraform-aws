#!/bin/bash

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting validation of all Terraform and Terragrunt configurations...${NC}"

# Validate Terraform formatting
echo -e "\n${YELLOW}Checking Terraform formatting...${NC}"
terraform fmt -recursive -check
echo -e "${GREEN}Terraform formatting check passed${NC}"

# Validate Terragrunt formatting
echo -e "\n${YELLOW}Checking Terragrunt formatting...${NC}"
terragrunt hclfmt --check
echo -e "${GREEN}Terragrunt formatting check passed${NC}"

# Run tflint
echo -e "\n${YELLOW}Running tflint...${NC}"
find . -type f -name "*.tf" -exec dirname {} \; | sort -u | while read -r dir; do
    echo "Checking directory: $dir"
    (cd "$dir" && tflint)
done
echo -e "${GREEN}tflint check passed${NC}"

# Run checkov
echo -e "\n${YELLOW}Running checkov...${NC}"
checkov --directory .
echo -e "${GREEN}Checkov security check passed${NC}"

# Run tfsec
echo -e "\n${YELLOW}Running tfsec...${NC}"
tfsec .
echo -e "${GREEN}tfsec security check passed${NC}"

# Validate documentation
echo -e "\n${YELLOW}Validating documentation...${NC}"
find . -type f -name "*.tf" -exec dirname {} \; | sort -u | while read -r dir; do
    if [ -f "$dir/README.md" ]; then
        echo "Checking documentation in: $dir"
        terraform-docs markdown table --output-file README.md --output-mode inject "$dir"
    fi
done
echo -e "${GREEN}Documentation validation passed${NC}"

# Validate Terragrunt configurations
echo -e "\n${YELLOW}Validating Terragrunt configurations...${NC}"
find . -type f -name "terragrunt.hcl" -exec dirname {} \; | while read -r dir; do
    echo "Validating Terragrunt config in: $dir"
    (cd "$dir" && terragrunt validate)
done
echo -e "${GREEN}Terragrunt validation passed${NC}"

echo -e "\n${GREEN}All validation checks completed successfully!${NC}"
