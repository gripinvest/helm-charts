# Grip Invest Helm Charts

This repository contains the official Helm charts for Grip Invest's Kubernetes deployments.

## Available Charts

| Chart | Description | Version |
|-------|-------------|---------|
| **[mark-I](./charts/mark-I)** | The foundational generic application chart. Supports Deployments, ArgoCD Rollouts (Canary & Blue-Green), and advanced configuration. | 1.2.0 |

---

## Mark-I Chart

The `mark-I` chart is a highly flexible, production-ready Helm chart designed to deploy a wide range of microservices and applications. It abstracts standard Kubernetes complexities while exposing powerful deployment strategies.

### Key Features

*   **Dual Deployment Modes**: Switch easily between standard Kubernetes `Deployment` and `ArgoCD Rollout` CRDs.
*   **Advanced Deployment Strategies**:
    *   **Canary**: Progressive traffic shifting.
    *   **Blue-Green**: Zero-downtime cutovers with preview environments.
*   **Integrated Observability**: Built-in support for Liveness, Readiness, and Startup probes.
*   **Security First**: Configurable Pod and Container security contexts.
*   **Full Resource Management**: Support for Requests/Limits, HPA, PodDisruptionBudgets, and Affinities.
*   **Storage & Config**: Easy management of PVCs, Secrets, and ConfigMaps.

### Usage & Configuration

#### 1. Standard Deployment (Default)
By default, the chart deploys a standard Kubernetes `Deployment`.

```yaml
# values.yaml
type: Deployment
replicaCount: 2
image:
  repository: my-app
  tag: v1.0.0
```

#### 2. ArgoCD Rollout: Blue-Green Strategy
Enable Blue-Green deployment to provision a preview environment before shifting traffic. This is ideal for manual verification.

```yaml
# values.yaml
type: Rollout

rollout:
  strategy:
    blueGreen:
      # Active service (Production traffic) - defaults to chart fullname
      activeService: mark-I

      # Preview service (Staging/Test traffic) - defaults to <fullname>-preview
      previewService: mark-I-preview

      # Set to false to wait for manual promotion in ArgoCD
      autoPromotionEnabled: false
```

#### 3. ArgoCD Rollout: Canary Strategy
Enable progressive delivery based on traffic percentage.

```yaml
# values.yaml
type: Rollout

rollout:
  strategy:
    canary:
      steps:
        - setWeight: 20
        - pause: {}          # Wait unconditionally (manual resume)
        - setWeight: 50
        - pause: { duration: 10 } # Wait 10s then proceed
```

### Installation

```bash
# Install the chart locally
helm install my-release ./charts/mark-I -f values.yaml

# Upgrade the release
helm upgrade my-release ./charts/mark-I -f values.yaml
```

## References

*   [ArgoCD Rollouts Documentation](https://argo-rollouts.readthedocs.io/en/stable/)
*   [Kubernetes Documentation](https://kubernetes.io/docs/home/)
