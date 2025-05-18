{{- define "common.ingress.domain" -}}
{{ .Values.global.ingress.domain | required ".Values.global.ingress.domain should be set" }}
{{- end -}}

{{- define "common.ingress.tls" -}}
{{- if .Values.global.ingress.tlsEnabled | required ".Values.global.ingress.tlsEnabled should be set" -}}
tls:
    - secretName: {{ .Values.global.ingress.tlsSecret | required ".Values.global.ingress.tlsSecret should be set" }}
      hosts:
        - {{ .Chart.Name }}.{{ .Values.global.ingress.domain }}
{{- end -}}
{{- end -}}