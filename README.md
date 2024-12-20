# CSL DR Terraform Infrastructure

## Prerequisites
- Terraform >= 1.0.0
- AWS CLI configured
- Make

## Usage

1. Create your input file with naming convention: `<env>-<version>-inputs.yaml`
   Example: `val-42-inputs.yaml`

2. Run commands in sequence:

```bash
# Initialize Terraform (use matching env and version from inputs file)
make init ENV=val VERSION=42

# Plan changes
make plan

# Apply changes
make apply

# Plan destruction (optional)
make plan-destroy

# Destroy infrastructure (optional)
make destroy
```

Note: Always ensure ENV and VERSION parameters match your inputs.yaml file prefix.
