{{- define "mies.kibanaservicename" -}}
{{- if not (empty .Values.kibana.service.fullnameOverride) -}}
{{- .Values.kibana.service.fullnameOverride -}}
{{- else if not (empty .Values.kibana.service.nameOverride) -}}
{{- .Release.Name }}-{{ .Values.kibana.service.nameOverride -}}
{{- else -}}
{{- .Release.Name }}-kibana-srv
{{- end -}}
{{- end -}}


{{- define "mies.elasticsearchmaestroservicename" -}}
{{- if not (empty .Values.elasticsearch.master.service.fullnameOverride) -}}
{{- .Values.elasticsearch.master.service.fullnameOverride -}}
{{- else if not (empty .Values.elasticsearch.master.service.nameOverride) -}}
{{- .Release.Name }}-{{ .Values.elasticsearch.master.service.nameOverride -}}
{{- else -}}
{{- .Release.Name }}-elasticsearch-maestro-srv
{{- end -}}
{{- end -}}

{{- define "mies.kibanadeployment" -}}
{{- .Release.Name }}-kibana
{{- end -}}

{{- define "mies.elasticsearchmaestrostatefulset" -}}
{{- .Release.Name }}-elasticsearch-maestro
{{- end -}}

{{- define "mies.secret" -}}
{{- .Release.Name }}-secret
{{- end -}}

{{- define "mies.kibanalabel" -}}
{{- .Release.Name }}-kibana
{{- end -}}

{{- define "mies.elasticsearchmaestrolabel" -}}
{{- .Release.Name }}-elasticsearch-maestro
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
