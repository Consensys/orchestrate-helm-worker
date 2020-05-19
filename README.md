# HELM Chart used to deploy Orchestrate

## Install plugin helm to deploy into jFrog Container Repository
use helm plugin [helm-push-artifactory-plugin](https://github.com/belitre/helm-push-artifactory-plugin)

```bash
helm plugin install https://github.com/belitre/helm-push-artifactory-plugin --version v0.3.0
```
_IMPORTANT_: need to have an `index.yaml` into the helm repo before adding repo to plugin


```bash
helm repo add --username <USER_ACCOUNT> --password <PASSWORD_ACCOUNT> helm-orchestrate https://pegasys.jfrog.io/artifactory/helm-orchestrate/
tar -czf core-stack-worker.tgz core-stack-worker
```


## Upload helm chart from CLI jFrog

```bash
brew install jfrog-cli-go
```

_From `orchestrate-helm` repository_
```bash
tar -czf core-stack-api.tgz core-stack-api
jfrog rt u core-stack-api.tgz helm-orchestrate --url https://pegasys.jfrog.io/artifactory/ --user <USER_ACCOUNT> --password <PASSWORD_ACCOUNT>
```

INFO:

`jfrog rt ping --url https://pegasys.jfrog.io/artifactory/`    
                                                           
To avoid this message in the future, set the `JFROG_CLI_OFFER_CONFIG` environment variable to `false`.