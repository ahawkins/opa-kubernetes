package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
	kubernetes.is_hpa
	input.spec.minReplicas > input.spec.maxReplicas
	msg = sprintf("[HPA-01] HorizontalPodAutoscaler %s must have less min replicas than max replicas", [ name ])
}
