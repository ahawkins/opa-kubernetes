# Rules

Refer to the acceptance test fixtures of passing examples of:

- [Common rules](test/fixtures/pass)
- [Datadog rules](test/fixtures/datadog)
- [User provided data](test/fixtures/data)

## MTA-01

Denies entities with an explicit `namespace`. Namespace should only be
sepcified by `kubectl apply --namespace`. Using an explicit
`namespace` creates confusion.

## MTA-02

Entity specifies labels defines [Kubernetes recommended
labels][labels].

## MTA-03

Entity template specifies labels defines [Kubernetes recommended
labels][labels].

## WRK-01

Resource `requests` and `limits` such that:

- `requests` <= `limits`
- CPU specified in floating point. Good: `1`. Bad: `1000m`
- Memory specified in `Mi` or `Gi`

## WRK-02

Container `volumeMount` names match a declared `volume`

## WRK-03

A declared `volumes` is mounted in at least one container.

## DPL-01

Containers set `livenessProbe` and `readinessProbe` of any type.

## DPL-02

`spec.selector.matchLabels` is a subset of
`spec.template.metadata.labels`. Ensures that a `Deployment` will not
be rejected by the Kubernetes API for a mismatched selector.

## DPL-03

Container `livenessProbe` and `readinessProbe` that specifies a port
matches a declared `containerPort`.

## JOB-01

Requires `Jobs` set an explicit `backoffLimit`. The default likely
does not work in all cases. This forces manifest authors to choose an
applicable `backoffLimit`.

## SEC-01

`Secret` using `data` specify valid Base64 encoded keys.

## HPA-01

`spec.minReplicas <= spec.maxReplicas`

## CMB-01

Container `envFrom` references a `ConfigMap` or `Secret` declared in
the manifests.

## CMB-02

Volumes populated from `ConfigMap` or `Secret` match one declared in
the manifests.

## CMB-03

`Service` label selector matches a `Deployment` template labels.

## CMB-04

`HorizontalPodAutoscaler` scale target matches an entity declared in
the manifests.

## CMB-05

`Service` target port matches a `containerPort` in the matching
`Deployment`.

## CMB-06

`Deployment` managed by an HPA does not declare replicas. This
conflicts with the HPA's settings.

## DOG-01

Workloads specify the `ad.datadoghq.com/tags` annotation.

Validate workloads set specific tags by by providing a data file to
`conftest`.

```
# data/datadog_required_tags.yaml
datadog_required_tags:
	- environment
	- service
```

Next pass the `-d` or `--data` argument to conftest:

```
conftest test --data data
```

## DOG-02

Workloads containers specify the `ad.datadoghq.com/$container.logs` annotation.

Example valid annotation:

```
ad.datadoghq.com/dummy.logs: |
	[{ "source": "docker", "service": "dummy" }]
```

Where `dummy` is a declared container.

[labels]: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels
