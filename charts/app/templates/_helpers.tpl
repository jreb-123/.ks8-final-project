{{- define "app.name" -}}
{{ .Chart.Name }}
{{- end -}}
{{- define "app.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end -}}
