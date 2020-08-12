package combined

deny[msg] {
	entity := entities[_]
	workload_kinds[entity.kind]
	container := entity.spec.template.spec.containers[_]
	envFrom := container.envFrom[_].configMapRef.name
	not config_maps_by_name[envFrom]
	msg = sprintf("[CMB-01] %s %s container %s envFrom must match a ConfigMap", [ entity.kind, entity.metadata.name, container.name ])
}

deny[msg] {
	entity := entities[_]
	workload_kinds[entity.kind]
	container := entity.spec.template.spec.containers[_]
	envFrom := container.envFrom[_].secretRef.name
	not secrets_by_name[envFrom]
	msg = sprintf("[CMB-01] %s %s container %s envFrom must match a Secret", [ entity.kind, entity.metadata.name, container.name ])
}
