{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "orchestrate-worker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "orchestrate-worker.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "orchestrate-worker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define imageCredentials name.
*/}}
{{- define "orchestrate-worker.imagePullSecretName" -}}
{{- if .Values.imageCredentials.create -}}
	{{ printf "%s-%s" (include "orchestrate-worker.fullname" .) "registry" | trunc 63 | trimSuffix "-" }}
{{- else -}}
	{{ .Values.imageCredentials.name }}
{{- end -}}
{{- end -}}

{{- define "orchestrate-worker.imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}

{{/*
Define imageCredentials name for test.
*/}}
{{- define "orchestrate-worker.imagePullSecretNameTest" -}}
{{- if .Values.testImageCredentials.create -}}
	{{ printf "%s-%s" (include "orchestrate-worker.fullname" .) "registry-test" | trunc 63 | trimSuffix "-" }}
{{- else -}}
	{{ .Values.testImageCredentials.name }}
{{- end -}}
{{- end -}}

{{- define "orchestrate-worker.imagePullSecretTest" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.testImageCredentials.registry (printf "%s:%s" .Values.testImageCredentials.username .Values.testImageCredentials.password | b64enc) | b64enc }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "orchestrate-worker.labels" -}}
helm.sh/chart: {{ include "orchestrate-worker.chart" . }}
{{ include "orchestrate-worker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "orchestrate-worker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "orchestrate-worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Define serviceAccountName name
*/}}
{{- define "orchestrate-worker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "orchestrate-worker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
