package main

import data.kubernetes

name = input.metadata.name

container_probes[p] {
	p := input.livenessProbe[_]
}

container_probes[p] {
	p := input.readinessProbe[_]
}

required_resources {
	input.resources

	requests := input.resources.requests
	limits := input.resources.limits

	is_number(requests.cpu)
	is_number(limits.cpu)
	requests.cpu <= limits.cpu

	is_string(requests.memory)
	is_string(limits.memory)
	memory_units := [ "Mi", "Gi" ]
	endswith(requests.memory, memory_units[_])
	units.parse_bytes(requests.memory) <= units.parse_bytes(limits.memory)
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	containers := template.spec.containers[_]
	not required_resources with input as containers
	msg = sprintf("[WRK-01] %s %s must specify valid resources for all containers", [input.kind, name])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	volumes := { volume | volume := template.spec.volumes[_].name }
	container := template.spec.containers[_]
	volume_mount := container.volumeMounts[_].name
	not volumes[volume_mount]
	msg = sprintf("[WRK-02] %s %s container %s volumeMount %s does not exist", [input.kind, name, container.name, volume_mount])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	volume_mounts := { volume | volume := template.spec.containers[_].volumeMounts[_].name }
	volume := template.spec.volumes[_].name
	not volume_mounts[volume]
	msg = sprintf("[WRK-03] %s %s must mount volume %s in a container", [input.kind, name, volume])
}
