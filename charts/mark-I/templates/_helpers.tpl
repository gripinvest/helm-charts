{{/*
Expand the name of the chart.
*/}}
{{- define "mark.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mark.fullname" -}}
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
{{- define "mark.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Get a websocket hostname from URL
*/}}
{{- define "wshostname" -}}
{{- . | trimPrefix "http://" |  trimPrefix "https://" | trimSuffix "/" | trim | printf "ws-%s" | quote -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mark.labels" -}}
helm.sh/chart: {{ include "mark.chart" . }}
{{ include "mark.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.extraLabels }}
{{ toYaml $.Values.extraLabels }}
{{- end }}

{{- end }}

{{/*
Selector labels
*/}}
{{- define "mark.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mark.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mark.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mark.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Check if the persistence is enabled, secret or configmaps are for mount */}}
  {{/* Iterate through the Volumes array */}}
    {{/* If the PVC or emptydir exists */}}
    {{/* If emptyDir is present */}}
    {{/* PVC name */}}

{{/* Check if the configmaps are present */}}
  {{/* Iterate through the configmaps array */}}
    {{/* Check is the configmap is for appenv */}}

{{/* This is the function to add the combined volumes from Volumes, secrets, configmaps and claimtemplate */}}
{{- define "mark.combinedVolumes" -}}
{{- if or .Values.persistence.enabled .Values.secrets .Values.configmaps}}

{{/* Include the Volumes under the Volumes section in the Values File */}}
{{- if and .Values.persistence.enabled (gt (len .Values.persistence.volumes) 0) }}
{{- range $volume := .Values.persistence.volumes }}
{{- $markName := include "mark.fullname" $ }}
- name: {{ $volume.name | default $markName }}
{{- if (hasKey $volume "emptyDir") }}
  emptyDir: {{- toYaml $volume.emptyDir | nindent 5 }}
{{- else if (hasKey $volume "nfs")}}
  nfs: {{- toYaml $volume.nfs | nindent 5 }}
{{- else }}
  persistentVolumeClaim:
    claimName: {{ $volume.name | default $markName}}
{{- end }}
{{- end }}
{{- end }}

{{/* Include the Secrets under the secrets section in the Values File  */}}
{{- if gt (len .Values.secrets) 0 }}
{{- range $secret := .Values.secrets }}
{{- if $secret.appenv }}
- name: {{ $secret.name }}
  secret:
    secretName: {{ $secret.name }}
    optional: false
{{- end }}
{{- end }}
{{- end }}

{{/* Include the ConfigMap under the configMap section in the Values File  */}}
{{- if gt (len .Values.configmaps) 0 }}
{{- range $configmap := .Values.configmaps }}
{{- if $configmap.appenv }}
- name: {{ $configmap.name }}
  configMap:
    name: {{ $configmap.name }}
    optional: false
{{- end }}
{{- end }}

{{- end }}
{{- end }}
{{- end }}


{{/* Check if the persistence is enabled, secret or configmaps are for mount*/}}
{{/* Iterate through the Volumes array */}}

{{/* Check if the secrets are present */}}
{{/* Iterate through the secrets array */}}
{{/* Check is the secrets is for app env */}}

{{/* Check if the configmap are present */}}
{{/* Iterate through the configmap array */}}
{{/* Check is the configs is for app env */}}
{{/* MAIN CONTAINERS: This is the function to add the combined volume mounts */}}
{{- define "mark.mainContainerCombinedVolumeMounts" -}}
{{- if or .Values.persistence.enabled .Values.secrets .Values.configmaps}}
{{- if gt (len .Values.persistence.volumes) 0 }}
{{- range $volume := .Values.persistence.volumes }}
{{- if ne $volume.mountContainer "init" }}
{{- $markName := include "mark.fullname" $ }}
- name: {{ $volume.name | default $markName }}
  mountPath: {{ $volume.mountPath | default "/mnt/mark"}}
  readOnly: {{ $volume.readOnly | default false}}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- if gt (len .Values.secrets) 0 }}
{{- range $secret := .Values.secrets }}
{{- if and $secret.appenv (ne $secret.mountContainer "init") }}
- name: {{ $secret.name }}
  mountPath: {{ $secret.mountPath | default (printf "/var/run/secrets/%s" ($secret.name)) }}
  readOnly: {{ $secret.readOnly | default true }}
{{- end }}
{{- end }}
{{- end }}

{{- if gt (len .Values.configmaps) 0 }}
{{- range $config := .Values.configmaps }}
{{- if and $config.appenv (ne $config.mountContainer "init") }}
- name: {{ $config.name }}
  mountPath: {{ $config.mountPath | default (printf "/etc/config/%s" ($config.name)) }}
  readOnly: {{ $config.readOnly | default true }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/* INIT CONTAINERS: This is the function to add the combined volume mounts */}}
{{- define "mark.initContainerCombinedVolumeMounts" -}}
{{- if or .Values.persistence.enabled .Values.secrets .Values.configmaps}}
{{- range $volume := .Values.persistence.volumes }}
{{- if or (eq $volume.mountContainer "init") (eq $volume.mountContainer "both") }}
{{- $markName := include "mark.fullname" $ }}
- name: {{ $volume.name | default $markName }}
  mountPath: {{ $volume.mountPath | default "/mnt/mark"}}
  readOnly: {{ $volume.readOnly | default false}}
{{- end }}
{{- end }}
{{- end }}
{{- end }}


{{/* MAIN CONTAINER : The Combined EnvFrom for the Main Container */}}
{{- define "mark.mainContainerCombinedEnvFrom" }}
{{- if or .Values.secrets .Values.configmaps }}
{{- range $k, $v := $.Values.secrets }}
{{- if and $v.appenv (ne $v.envFrom false) (ne $v.mountContainer "init") }}
  - secretRef:
      name: {{ $v.name }}
{{- end }}
{{- end }}
{{- range $k, $c := $.Values.configmaps }}
{{- if and $c.appenv (ne $c.envFrom false) (ne $c.mountContainer "init") }}
  - configMapRef:
      name: {{ $c.name }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/* INIT CONTAINER: The Combined EnvFrom */}}
{{- define "mark.initContainerCombinedEnvFrom" }}
{{- if or .Values.secrets .Values.configmaps }}
{{- range $k, $v := $.Values.secrets }}
{{- if and $v.appenv (ne $v.envFrom false) (or (eq $v.mountContainer "init") (eq $v.mountContainer "both")) }}
  - secretRef:
      name: {{ $v.name }}
{{- end }}
{{- end }}
{{- range $k, $c := $.Values.configmaps }}
{{- if and $c.appenv (ne $c.envFrom false) (or (eq $c.mountContainer "init") (eq $c.mountContainer "both")) }}
  - configMapRef:
      name: {{ $c.name }}
{{- end }}
{{- end }}
{{- else }}
{{ default (list) }}
{{- end }}
{{- end }}
