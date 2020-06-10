# Helm Charts

This GitHub project is the source for Orchestrate Helm chart repositories.

For more information about installing and using Helm, see the Helm Docs. For a quick introduction to Charts, see the Chart Guide.

## Usage

The Helm Charts are pushed to the following public repository: https://pegasys.jfrog.io/artifactory/helm-pegasys/

The available Charts are listed below:
* core-stack-worker
* core-stack-api
* vault (DEPRECATED - the recommended way is to use the [BankVault](https://github.com/banzaicloud/bank-vaults) project)
* vault-api-python (DEPRECATED - the recommended way is to use the [BankVault](https://github.com/banzaicloud/bank-vaults) project)

For an example on how to use these charts, please see the [orchestrate-kubernetes](https://github.com/PegaSysEng/orchestrate-kubernetes) project.

## Contributing

### Helm
[Install helm](https://helm.sh/docs/intro/install/) locally

### Helm push-artifactory plugin
Install helm plugin [helm-push-artifactory-plugin](https://github.com/belitre/helm-push-artifactory-plugin)

```bash
helm plugin install https://github.com/belitre/helm-push-artifactory-plugin --version v1.0.1
```
_IMPORTANT_: need to have an `index.yaml` into the helm repo before adding repo to plugin

### Add the helm-orchestrate repository
```bash
helm repo add --username <USER_ACCOUNT> --password <PASSWORD_ACCOUNT> helm-orchestrate https://pegasys.jfrog.io/artifactory/helm-orchestrate/
```

## Release a new version

First of all, don't forget to upgrade the version number of the Helm Chart before proceeding by changing the version number in `Chart.yaml` file in each Helm Chart folder impacted. 

Then, to push the new chart release to the repository, run:
```bash
make push-api

make push-worker
```

or both at the same time using
```bash
make push
```
