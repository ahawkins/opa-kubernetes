package main

import data.kubernetes

name = input.metadata.name

required_liveness_probe {
	probes := [ probe | probe := input[_].livenessProbe ]
	count(probes) == count(input)
}

required_readiness_probe {
	probes := [ probe | probe := input[_].readinessProbe ]
	count(probes) == count(input)
}

deny[msg] {
	kubernetes.is_deployment
	not required_liveness_probe with input as input.spec.template.spec.containers
	msg = sprintf("[DPL-01] Deployment %s must specify liveness probes for all containers", [ name ])
}

deny[msg] {
	kubernetes.is_deployment
	not required_readiness_probe with input as input.spec.template.spec.containers
	msg = sprintf("[DPL-01] Deployment %s must specify readiness probes for all containers", [ name ])
}


matching_label_selector {
	selectors := { [ label, value ] | some label; value := input.spec.selector.matchLabels[label] }
	labels := { [ label, value ] | some label; value := input.spec.template.metadata.labels[label] }
	count(selectors - labels) == 0
}

required_label_selector {
	count(input.spec.selector.matchLabels) > 0
	count(input.spec.template.metadata.labels) > 0
}

deny[msg] {
	kubernetes.is_deployment
	not required_label_selector
	msg = sprintf("[DPL-02] Deployment %s must specify selector and template labels", [ name ])
}

deny[msg] {
	kubernetes.is_deployment
	not matching_label_selector
	msg = sprintf("[DPL-02] Deployment %s selector must match template labels", [ name ])
}

container_probes[p] {
	p := input.livenessProbe[_]
}

container_probes[p] {
	p := input.readinessProbe[_]
}

deny[msg] {
	kubernetes.is_deployment
	container := input.spec.template.spec.containers[_]
	probes := container_probes with input as container
	probe_ports := { port | port := probes[_].port }
	container_ports := { port | port := container.ports[_].containerPort }

	count(probe_ports - container_ports) != 0
	msg = sprintf("[DPL-03] Deployment %s container %s probes port must match container port", [ name, container.name ])
}
