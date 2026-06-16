{{/*
Expand the name of the chart.
*/}}
{{- define "sunbird-rc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "sunbird-rc.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels applied to chart resources.
*/}}
{{- define "sunbird-rc.labels" -}}
helm.sh/chart: {{ include "sunbird-rc.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Deployment replica count — omitted when HPA manages scaling.
Expected dict keys: autoscaling (map), replicaCount (optional int).
*/}}
{{- define "sunbird-rc.deploymentReplicas" -}}
{{- $autoscaling := .autoscaling -}}
{{- if not $autoscaling.enabled -}}
replicas: {{ .replicaCount | default 1 }}
{{- end -}}
{{- end -}}

{{/*
Standard HorizontalPodAutoscaler (autoscaling/v2, CPU + optional memory).
Expected dict keys:
  root, enabled, autoscaling, hpaName, deploymentName, app
*/}}
{{- define "sunbird-rc.hpa" -}}
{{- if and .enabled .autoscaling.enabled }}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .hpaName }}
  labels:
    app: {{ .app }}
    {{- include "sunbird-rc.labels" .root | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .deploymentName }}
  minReplicas: {{ .autoscaling.minReplicas }}
  maxReplicas: {{ .autoscaling.maxReplicas }}
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .autoscaling.targetCPUUtilizationPercentage }}
    {{- if .autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ .autoscaling.targetMemoryUtilizationPercentage }}
    {{- end }}
{{- end }}
{{- end -}}

{{/*
Default container resources for stateless HTTP/API workloads.
Expected dict keys: cpu (request), memory (request), cpuLimit, memoryLimit
*/}}
{{- define "sunbird-rc.resources.default" -}}
resources:
  requests:
    cpu: {{ .cpu | default "200m" }}
    memory: {{ .memory | default "256Mi" }}
  limits:
    cpu: {{ .cpuLimit | default "500m" }}
    memory: {{ .memoryLimit | default "512Mi" }}
{{- end -}}

{{/*
Lightweight container resources (proxies, static frontends).
*/}}
{{- define "sunbird-rc.resources.light" -}}
resources:
  requests:
    cpu: {{ .cpu | default "100m" }}
    memory: {{ .memory | default "128Mi" }}
  limits:
    cpu: {{ .cpuLimit | default "300m" }}
    memory: {{ .memoryLimit | default "256Mi" }}
{{- end -}}

{{/*
Heavy JVM / application server resources.
*/}}
{{- define "sunbird-rc.resources.heavy" -}}
resources:
  requests:
    cpu: {{ .cpu | default "500m" }}
    memory: {{ .memory | default "512Mi" }}
  limits:
    cpu: {{ .cpuLimit | default "1000m" }}
    memory: {{ .memoryLimit | default "1Gi" }}
{{- end -}}
