#!/bin/sh
# Sanity Checks
if [ -z "${VAULT_ADDR}" ]; then echo "\$VAULT_ADDR must be set."; exit 5; fi
command -v vault 1>/dev/null || (echo "'vault' must be installed and available in \$PATH."; exit 6;)
command -v aws 1>/dev/null || (echo "'aws' must be installed and available in \$PATH."; exit 7)
command -v jq 1>/dev/null || (echo "'jq' must be installed and available in \$PATH."; exit 8)
aws secretsmanager describe-secret --secret-id "${AWS_SECRET_ID}" 1>/dev/null || (echo "AWS Secret ${AWS_SECRET_ID} could not be described"; exit 9)
echo "Sanity check ok."
# Get Vault Token
set -e +x
ROOT_TOKEN=$(aws secretsmanager get-secret-value --secret-id "${AWS_SECRET_ID}" | jq -r '.SecretString | fromjson | .root_token' )
vault login -no-print "${ROOT_TOKEN}"