# Kubernetes Manifest Policies

## Metadata

- MTA-01: no `namespace` set
- MTA-02: mandatory labels
- MTA-03: workload template labels

## Workloads

Applies to: `Deployment`, `Job`

- WRK-01: containers set resource requests and limits
- WRK-02: `volumeMount` matches `volume`
- WRK-03: `volumes` are mounted

## Deployments

- DPL-01: containers set liveness and readiness probes
- DPL-02: selector matches template labels
- DPL-03: liveness and readiness probes match container port

## Job

- JOB-01: explicit `backoffLimit` set

## Secrets

- SEC-01: base64 encoded secrets contain valid Base64 encoded keys

## HorizontalPodAutoScaler

- HPA-01: Less minimum than maximum replicas

## Combined

- CMB-01: container `envFrom` matches a `ConfigMap` or `Secret` in the manifests
- CMB-02: volume from matches `ConfigMap` or `Secret`
- CMB-03: `Service` selector matches a `Deployment`
- CMB-04: `HorizontalPodAutoscaler` scaling target matches a `Deployment`
- CMB-05: Service port matches container port
- CMB-06: HPA managed deployment does not set replicas
