{{- define "trainingsapp.fullname" -}}
{{- .Release.Name | trunc 50 | trimSuffix "-" -}}
{{- end -}}

{{- define "trainingsapp.commonLabels" -}}
app.kubernetes.io/part-of: trainingsapp
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "trainingsapp.secretName" -}}
{{- if .Values.server.secret.existingSecret -}}
{{ .Values.server.secret.existingSecret }}
{{- else -}}
{{ include "trainingsapp.fullname" . }}-server-secret
{{- end -}}
{{- end -}}

{{- define "trainingsapp.webauthnRpId" -}}
{{- if .Values.server.webauthn.rpId -}}
{{ .Values.server.webauthn.rpId }}
{{- else -}}
{{ .Values.ingress.host }}
{{- end -}}
{{- end -}}

{{- define "trainingsapp.webauthnOrigins" -}}
{{- if .Values.server.webauthn.origins -}}
{{ .Values.server.webauthn.origins }}
{{- else if .Values.ingress.tls.enabled -}}
https://{{ .Values.ingress.host }}
{{- else -}}
https://{{ .Values.ingress.host }}
{{- end -}}
{{- end -}}
