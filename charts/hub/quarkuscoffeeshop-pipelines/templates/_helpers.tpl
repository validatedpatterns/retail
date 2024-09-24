{{/* vim: set filetype=mustache: */}}

{{/*
Set the hostname for the imageregistry if type is openshift-internal
*/}}
{{- define "quarkuscoffeeshop-pipelines.imageRegistryHostname" -}}
{{- if (eq .Values.global.imageregistry.type "openshift-internal") -}}
registry.{{- .Values.global.hubClusterDomain -}}
{{- else }}
{{- .Values.global.imageregistry.hostname -}}
{{- end }}
{{- end }}
