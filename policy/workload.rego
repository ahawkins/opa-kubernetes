package main

import data.kubernetes

name = input.metadata.name

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
	containers := input.spec.template.spec.containers[_]
	not required_resources with input as containers
	msg = sprintf("[WRK-01] %s %s must specify valid resources for all containers", [input.kind, name])
}

valid_volume_mounts {
	volumes := { volume | volume := input.volumes[_].name }
	volume_mounts := { volume | volume := input.containers[_].volumeMounts[_].name }

	count(volume_mounts - volumes) == 0
}

deny[msg] {
	kubernetes.is_workload
	spec := input.spec.template.spec
	not valid_volume_mounts with input as spec
	msg = sprintf("[WRK-02] %s %s container volumeMounts must reference volumes", [input.kind, name])
}

all_volumes_mounted {
	volumes := { volume | volume := input.volumes[_].name }
	volume_mounts := { volume | volume := input.containers[_].volumeMounts[_].name }

	count(volume_mounts) == count(volumes)
}

deny[msg] {
	kubernetes.is_workload
	spec := input.spec.template.spec
	not all_volumes_mounted with input as spec
	msg = sprintf("[WRK-03] %s %s must mount all declared volumes", [input.kind, name])
}
