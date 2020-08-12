package main

import data.kubernetes

name = input.metadata.name

sane_hpa_replicas {
	input.minReplicas <= input.maxReplicas
}

deny[msg] {
	kubernetes.is_hpa
	not sane_hpa_replicas with input as input.spec
	msg = sprintf("[HPA-01] HorizontalPodAutoscaler %s must have less min replicas than max replicas", [ name ])
}
