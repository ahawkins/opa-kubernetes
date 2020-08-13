package combined

deny[msg] {
	entity := entities[_]
	workload_kinds[entity.kind]
	volume := entity.spec.template.spec.volumes[_]
	config_map := volume.configMap.name
	not config_maps_by_name[config_map]

	msg = sprintf("[CMB-02] %s %s volume %s must match a ConfigMap", [entity.kind, entity.metadata.name, volume.name])
}

deny[msg] {
	entity := entities[_]
	workload_kinds[entity.kind]
	volume := entity.spec.template.spec.volumes[_]
	secret := volume.secret.secretName
	not secrets_by_name[secret]

	msg = sprintf("[CMB-02] %s %s volume %s must match a Secret", [entity.kind, entity.metadata.name, volume.name])
}
