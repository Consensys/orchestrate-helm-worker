{{- define "enable-secrets" -}}
if ! vault secrets tune {{ .Values.vault.provision.secretsPath }} 2>/dev/null ; then
	vault secrets enable -path={{ .Values.vault.provision.secretsPath }} -version=2 kv
fi
{{- end }}
{{- define "write-policies" -}}
{{- range $policy := .Values.vault.provision.policies -}}
vault policy write {{ $policy.name | quote }} /provision/{{ $policy.name }}.hcl
{{ end }}
{{- end -}}
{{- define "write-roles" -}}
{{ range $role := .Values.vault.provision.roles -}}
vault write auth/kubernetes/role/{{ $role.name }} \
	bound_service_account_names={{ join "," $role.serviceAccountNames | quote }} \
	bound_service_account_namespaces={{ join "," $role.serviceAccountNamespaces | quote }} \
	policies={{ join "," $role.policies | quote }}
	ttl={{ default "72h" $role.ttl | quote }}
{{ end }}
{{- end }}