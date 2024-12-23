#!/bin/bash

# GoDaddy API Configuration
API_KEY="xxx"
API_SECRET="xxx"
DOMAIN="sycamoreinformatics.de"

# Load Balancer DNS names from Terraform output
SAS_ALB_DNS=$(terraform output -raw sas_alb_dns)
GUAC_ALB_DNS=$(terraform output -raw guac_alb_dns)
CDR_NLB_DNS=$(terraform output -raw cdr_nlb_dns)
SFTP_NLB_DNS=$(terraform output -raw sftp_nlb_dns)

SFTP_NAME="sftp-csl-val-dr"
CDR_NAME="cdr-csl-val-dr"
SAS_NAME="sas-csl-val-dr"
GUAC_NAME="wde-csl-val-dr"

# Function to add/update CNAME record
add_cname_record() {
    local name=$1
    local value=$2
    local ttl=600  # Time to live in seconds

    # Prepare JSON data
    json_data=$(cat <<EOF
[{
    "data": "$value",
    "name": "$name",
    "ttl": $ttl,
    "type": "CNAME"
}]
EOF
)

    # Call GoDaddy API to update DNS record
    response=$(curl -s -X PUT \
        -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
        -H "Content-Type: application/json" \
        -d "$json_data" \
        "https://api.godaddy.com/v1/domains/${DOMAIN}/records/CNAME/${name}")

    # Check if update was successful
    if [ -z "$response" ]; then
        echo "Successfully updated CNAME record for ${name}.${DOMAIN}"
    else
        echo "Error updating CNAME record for ${name}.${DOMAIN}: $response"
        exit 1
    fi
}

# Main execution
echo "Adding DNS records for load balancers..."

# Add CNAME for SAS ALB
if [ -n "$SAS_ALB_DNS" ]; then
    add_cname_record "$SAS_NAME" "$SAS_ALB_DNS"
else
    echo "Error: SAS ALB DNS name not found in Terraform output"
    exit 1
fi

# Add CNAME for GUAC ALB
if [ -n "$GUAC_ALB_DNS" ]; then
    add_cname_record "$GUAC_NAME" "$GUAC_ALB_DNS"
else
    echo "Error: GUAC ALB DNS name not found in Terraform output"
    exit 1
fi

# Add CNAME for CDR NLB
if [ -n "$CDR_NLB_DNS" ]; then
    add_cname_record "$CDR_NAME" "$CDR_NLB_DNS"
else
    echo "Error: CDR NLB DNS name not found in Terraform output"
    exit 1
fi

# Add CNAME for SFTP NLB
if [ -n "$SFTP_NLB_DNS" ]; then
    add_cname_record "$SFTP_NAME" "$SFTP_NLB_DNS"
else
    echo "Error: SFTP NLB DNS name not found in Terraform output"
    exit 1
fi


echo "DNS records added successfully!"
