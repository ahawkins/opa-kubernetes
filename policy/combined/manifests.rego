package combined

entities[e] {
	entity := input[_]
	is_object(entity)
	e := entity
}

entities[e] {
	list := input[_]
	is_array(list)
	e := list[_]
}

services_by_name := {metadata.name: entity |
	e := entities[_]
	e.kind == "Service"
	metadata := e.metadata
	entity := e
}

deployments_by_name := {metadata.name: entity |
	e := entities[_]
	e.kind == "Deployment"
	metadata := e.metadata
	entity := e
}

config_maps_by_name := {metadata.name: entity |
	e := entities[_]
	e.kind == "ConfigMap"
	metadata := e.metadata
	entity := e
}

config_map_names := {name | some name; config_maps_by_name[name]}

secrets_by_name := {metadata.name: entity |
	e := entities[_]
	e.kind == "Secret"
	metadata := e.metadata
	entity := e
}

secret_names := {name | some name; secrets_by_name[name]}

workload_kinds := {"Deployment", "Job"}
