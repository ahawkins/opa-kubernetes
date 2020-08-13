# Kubernetes Manifest Policies

## Metadata

- [MTA-01](RULES.md#MTA-01): no `namespace` set
- [MTA-02](RULES.md#MTA-02): mandatory labels
- [MTA-03](RULES.md#MTA-03): workload template labels

## Workloads

Applies to: `Deployment`, `Job`, `CronJob`

- [WRK-01](RULES.md#WRK-01): containers set resource requests and limits
- [WRK-02](RULES.md#WRK-02): `volumeMount` matches `volume`
- [WRK-03](RULES.md#WRK-03): `volumes` are mounted

## Deployments

- [DPL-01](RULES.md#DPL-01): containers set liveness and readiness probes
- [DPL-02](RULES.md#DPL-02): selector matches template labels
- [DPL-03](RULES.md#DPL-03): liveness and readiness probes match container port

## Job

- [JOB-01](RULES.md#JOB-01): explicit `backoffLimit` set

## Secrets

- [SEC-01](RULES.md#SEC-01): base64 encoded secrets contain valid Base64 encoded keys

## HorizontalPodAutoScaler

- [HPA-01](RULES.md#HPA-01): Less minimum than maximum replicas

## Combined

- [CMB-01](RULES.md#CMB-01): container `envFrom` matches a `ConfigMap` or `Secret` in the manifests
- [CMB-02](RULES.md#CMB-02): volume from matches `ConfigMap` or `Secret`
- [CMB-03](RULES.md#CMB-03): `Service` selector matches a `Deployment`
- [CMB-04](RULES.md#CMB-04): `HorizontalPodAutoscaler` scaling target matches a `Deployment`
- [CMB-05](RULES.md#CMB-05): Service port matches container port
- [CMB-06](RULES.md#CMB-06): HPA managed deployment does not set replicas

## DataDog

Applies to: `Deployment`, `Job`, `CronJob`

- [DOG-01](RULES.md#DOG-01): Annotated with required tags
- [DOG-02](RULES.md#DOG-02): Containers annotated for log collection
