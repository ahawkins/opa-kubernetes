package contrib.datadog

import data.kubernetes

name = input.metadata.name

unmapped_datadog_log_annotation {
	containers := { container | container := input.spec.containers[_].name }
	annotations := {
		annotation |
    keys := { key | some key; input.metadata.annotations[key] }
		key := keys[_]
		startswith(key, "ad.datadoghq.com/",)
		endswith(key, ".logs")
		annotation := key
	}
	count(containers) != count(annotations)
}

required_datadog_container_logging {
	containers := { container | container := input.spec.containers[_].name }
	annotations := {
		annotation |
		annotation_keys := { key | key := sprintf("ad.datadoghq.com/%s.logs", [ containers[_] ]) }
		raw := input.metadata.annotations[annotation_keys[_]]
		annotation := json.unmarshal(raw)
	}
	count(containers) == count(annotations)

	valid_source_annotations = [ flag | flag := annotations[_].source == "docker" ]
	count(valid_source_annotations) == count(annotations)
	all(valid_source_annotations)

	valid_service_annotations = [ flag | flag := count(annotations[_].service) > 0 ]
	count(valid_service_annotations) == count(annotations)
	all(valid_service_annotations)
}

deny[msg] {
  kubernetes.is_deployment
	not required_datadog_container_logging with input as input.spec.template
  msg = sprintf("%s must include Datadog log annotations for all containers.", [name])
}

deny[msg] {
  kubernetes.is_deployment
	unmapped_datadog_log_annotation with input as input.spec.template
  msg = sprintf("%s must not include Datadog log annotations for missing contaienrs", [name])
}
