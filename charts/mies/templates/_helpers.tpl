{{- define "mies.kibanaservicename" -}}
{{- with .Values.kibana.service }}
{{- if not (empty .fullnameOverride) -}}
{{- .fullnameOverride -}}
{{- else if not (empty .nameOverride) -}}
{{- $.Release.Name }}-{{ .nameOverride -}}
{{- else -}}
{{- $.Release.Name }}-kibana-srv
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "mies.elasticsearchservicename" -}}
{{- if not (empty .fullnameOverride) -}}
{{- .fullnameOverride -}}
{{- else if not (empty .nameOverride) -}}
{{- .ReleaseName }}-{{ .nameOverride -}}
{{- else -}}
{{- .ReleaseName }}-elasticsearch-{{ .ServiceName }}-srv
{{- end -}}
{{- end -}}

{{- define "mies.kibanadeployment" -}}
{{- .Release.Name }}-kibana
{{- end -}}

{{- define "mies.elasticsearchstatefulset" -}}
{{- .Release.Name }}-elasticsearch-
{{- end -}}

{{- define "mies.secret" -}}
{{- .Release.Name }}-secret
{{- end -}}

{{- define "mies.kibanalabel" -}}
{{- .Release.Name }}-kibana
{{- end -}}

{{- define "mies.elasticsearchlabel" -}}
{{- .Release.Name }}-elasticsearch-
{{- end -}}

{{- define "mies.extralabels" -}}
{{- range $clave, $valor := . -}}
{{- $clave }}: {{ $valor | quote }}
{{ end -}}
{{- end -}}



{{/*
Expand the name of the chart.
*/}}
{{- define "mies.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mies.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mies.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mies.labels" -}}
helm.sh/chart: {{ include "mies.chart" . }}
{{ include "mies.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mies.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mies.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mies.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mies.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
