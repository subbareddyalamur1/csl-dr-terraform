.PHONY: init plan apply plan-destroy destroy

# Validate required arguments
check_args:
	@if [ -z "$(ENV)" ]; then \
		echo "ENV argument is required"; \
		exit 1; \
	fi
	@if [ -z "$(VERSION)" ]; then \
		echo "VERSION argument is required"; \
		exit 1; \
	fi

# Setup working directory and configuration
setup: check_args
	@if [ ! -f "../$(ENV)-$(VERSION)-inputs.yaml" ]; then \
		echo "Input file $(ENV)-$(VERSION)-inputs.yaml not found"; \
		exit 1; \
	fi
	@# Copy inputs file to terraform version directory
	@cp ../$(ENV)-$(VERSION)-inputs.yaml ./inputs.yaml
	@sleep 5
	@# Create backend.tf file
	@echo "terraform {" > backend.tf
	@echo "  backend \"s3\" {" >> backend.tf
	@echo "    bucket = \"$(shell grep tf_state_bucket_name inputs.yaml | cut -d':' -f2 | tr -d ' ')\"" >> backend.tf
	@echo "    key    = \"$(shell grep tf_state_path inputs.yaml | cut -d':' -f2 | tr -d ' ')\"" >> backend.tf
	@echo "    region = \"$(shell grep aws_region inputs.yaml | cut -d':' -f2 | tr -d ' ')\"" >> backend.tf
	@echo "  }" >> backend.tf
	@echo "}" >> backend.tf

# Initialize Terraform
init: setup
	 terraform init

# Plan Terraform changes
plan: 
	terraform plan 

# Apply Terraform changes
apply: 
	terraform apply -auto-approve

# Plan destruction of resources
plan-destroy: 
	terraform plan -destroy

# Destroy resources
destroy: 
	terraform destroy -auto-approve

clean:
	@echo "Cleaning up..."
	rm -f backend.tf
	rm -f inputs.yaml
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*
	rm -f *.zip