#!/bin/sh
# Sanity Checks
if [ -z "${VAULT_ADDR}" ]; then echo "\$VAULT_ADDR must be set."; exit 5; fi
command -v vault 1>/dev/null || (echo "'vault' must be installed and available in \$PATH."; exit 6)
command -v aws 1>/dev/null || (echo "'aws' must be installed and available in \$PATH."; exit 7)
command -v jq 1>/dev/null || (echo "'jq' must be installed and available in \$PATH."; exit 8)
aws secretsmanager describe-secret --secret-id "${AWS_SECRET_ID}" 1>/dev/null || (echo "AWS Secret ${AWS_SECRET_ID} could not be described"; exit 8)
echo "Sanity check ok."
# Init if necessary
counter=10
while [ $((counter=counter-1)) -ge 0 ]; do
vault operator init -status
VAULT_INIT_STATUS=$?
if [ ${VAULT_INIT_STATUS} -eq 0 ]; then
  exit 0
elif [ ${VAULT_INIT_STATUS} -eq 1 ]; then
  echo "Could not connect to ${VAULT_ADDR}"
  sleep 2
elif [ ${VAULT_INIT_STATUS} -eq 2 ]; then
  echo "Initializing vault..."
  break
else
  echo "Unhandled vault operator exit code: ${VAULT_INIT_STATUS}"
  exit 127
fi
done
set -e +x
vault operator init -recovery-shares=1 -recovery-threshold=1 -format=json > /secret/vault.json
aws secretsmanager put-secret-value --secret-id "${AWS_SECRET_ID}" --secret-string file:///secret/vault.json
ROOT_TOKEN=$(jq .root_token -r < /secret/vault.json)
shred -z /secret/vault.json
sleep 5
vault login -no-print "${ROOT_TOKEN}"
vault auth enable kubernetes
vault write auth/kubernetes/config \
  token_reviewer_jwt=@/var/run/secrets/kubernetes.io/serviceaccount/token \
  kubernetes_host=https://${KUBERNETES_SERVICE_HOST} \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
shred -z ~/.vault-token
exit 0
