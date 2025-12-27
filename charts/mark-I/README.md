# mark-1

![Version: 1.4.0](https://img.shields.io/badge/Version-1.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| prayas | <prayas.mittal@gripivest.in> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalContainers | list | `[]` |  |
| additionalIngress | object | `{}` |  |
| affinity | object | `{}` | Affinity, the values of the affinity is identical to the syntax in k8s manifests. [Refer this](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| autoscaling | object | `{"averageCPUUtilizationPercentage":80,"enabled":true,"maxReplicas":10,"minReplicas":1}` | HPA configuration for the workloads |
| autoscaling.enabled | bool | `true` | Enable the autoscaler |
| configmaps | list | `[]` | Create k8s configmaps, define the mount container, key value pairs and files, option to inject in application env Details of execution and config will be found in README document. |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsUser":1001}` | [Container security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container), this is implemented at the container level |
| containerSecurityContext.readOnlyRootFilesystem | bool | `true` | The filesystem of the container will be read only and no file manipulations are allowed, use volume mounts for such actions |
| extraEnv | object | `{}` | These are the environment variables ( key,values pairs) which we inject in the container |
| extraLabels | object | `{}` | Extra Labels we need to include in the pod or contianer deployments. |
| fullnameOverride | string | `"mark-I"` | Provide a name to the Helm release, usually its a good practice to specify the name here instead of using default chart name. |
| image | string | `{"name":"","pullPolicy":"IfNotPresent","repository":"nginx","tag":""}` | image respository |
| image.name | string | `""` | Name of the container image |
| image.tag | string | `""` | Image tag (immutable tags are recommended), Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | array | `[{"name":"gitlab-registry"}]` | Refer to the K8s docker container registry secrets, there could be one or more secrets. |
| ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| initContianerImage | object | `{}` | This is the Init container configuration, a detailed schema of this can be found in `complete-sample-values.yaml` file. |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.path | string | `"/"` |  |
| livenessProbe.periodSeconds | int | `15` |  |
| livenessProbe.probeType | string | `"httpGet"` | The probeType by default is httpGet and the port is considered as container port for healthcheck requests |
| livenessProbe.scheme | string | `"HTTP"` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `15` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | [Node selector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) for the workloads to get scheduled, identical to the syntax in k8s manifests |
| persistence | object | `{"enabled":false,"volumes":[]}` | Supports persistence, configure creation of PVC, NFS mounts, emptydir, mount contianers Details of execution and config will be found in README document. |
| persistence.enabled | bool | `false` | Enable the Volumes in pods manifest |
| podAnnotations | object | `{}` | Pod annotations |
| podDisruptionBudget.enabled | bool | `false` |  |
| podSecurityContext | object | `{"fsGroup":1001,"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001,"seccompProfile":{"type":"RuntimeDefault"}}` | [Pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod), this is implemented at the pod level |
| podSecurityContext.runAsNonRoot | bool | `true` | If set to true, the application won't be able to perform any root user actions at runtime |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `15` |  |
| readinessProbe.path | string | `"/"` |  |
| readinessProbe.periodSeconds | int | `15` |  |
| readinessProbe.probeType | string | `"httpGet"` | The probeType by default is httpGet and the port is considered as container port for healthcheck requests |
| readinessProbe.scheme | string | `"HTTP"` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| replicaCount | int | `1` | Replica Count, this works for Deployment and Statefulset. |
| resources | object | `{}` | We usually recommend not to specify default resources and to leave this as a conscious choice for the user. This also increases chances charts run on environments with little resources. limits:   cpu: 100m   memory: 128Mi requests:   cpu: 100m   memory: 128Mi |
| restartPolicy | string | `""` |  |
| rollout | object | `{"strategy":{"blueGreen":{"autoPromotionEnabled":false,"scaleDownDelaySeconds":1800}}}` | ArgoCD Rollout configuration To use Rollout, make sure to set `type: Rollout` at the top level. |
| rollout.strategy.blueGreen | object | `{"autoPromotionEnabled":false,"scaleDownDelaySeconds":1800}` | Blue-Green Strategy configuration This strategy defines a preview service and an active service. New Rollouts are exposed on the preview service first. Promotion to active service triggers a traffic switch. |
| rollout.strategy.blueGreen.autoPromotionEnabled | bool | `false` | Set to false for manual promotion (requires user intervention via ArgoCD UI/CLI to switch traffic) If true, promotion happens automatically after the new replicaset is ready. |
| rollout.strategy.blueGreen.scaleDownDelaySeconds | int | `1800` | Optional: Delay in seconds before scaling down the old replicaset after promotion This allows for a quick rollback if needed. |
| secrets | list | `[]` | Create k8s secrets, define the mount container, key value pairs and files, option to inject in application env Details of execution and config will be found in README document. |
| securityContext | bool | `true` | Global flag to enable or disbale the [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) in the workloads, if set to false, the values provided for security won't take effect |
| service | object | `{"containerPort":5000,"enabled":true,"port":80,"type":"ClusterIP"}` | Service discovery for the workload. |
| service.containerPort | int | `5000` | The port on which the application inside the contianer is running/accessable |
| service.enabled | bool | `true` | Enable the service |
| service.port | int | `80` | The port on which service is exposed |
| service.type | string | `"ClusterIP"` | Type of the service, values could be ClusterIP, NodePort, LoadBalancer, ExternalName |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Creation of the service kubernetes service account and used by the type of k8s object deployed though the chart |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account (eg: for workload identity) |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullnameOverride. |
| startupProbe | object | `{}` | kubelet uses startup probes to know when a container application has started |
| tolerations | list | `[]` | [Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for the workloads, identical to the syntax in k8s manifests |
| type | string | `"Deployment"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
