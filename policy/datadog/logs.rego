package datadog

import data.kubernetes

name = input.metadata.name

valid_log_config {
	config := json.unmarshal(input)
	is_array(config)
	count(config) == 1
	entry = config[0]
	entry.source == "docker"
	count(entry.service) > 0
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	container := template.spec.containers[_]
	annotation_name := sprintf("ad.datadoghq.com/%s.logs", [container.name])
	not template.metadata.annotations[annotation_name]
	msg = sprintf("[DOG-02] %s must include Datadog log annotations for all containers.", [name])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	some annotation
	raw := template.metadata.annotations[annotation]
	glob.match("ad.datadoghq.com/*.logs", [], annotation)
	not valid_log_config with input as raw
	msg = sprintf(`[DOG-02] %s %s annotation %s must specify valid log config`, [input.kind, name, annotation])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	container_annotations := {name |
		container := template.spec.containers[_]
		name := sprintf("ad.datadoghq.com/%s.logs", [container.name])
	}

	some annotation
	raw := template.metadata.annotations[annotation]
	glob.match("ad.datadoghq.com/*.logs", [], annotation)
	not container_annotations[annotation]
	msg = sprintf(`[DOG-02] %s %s annotation %s must match a container name`, [input.kind, name, annotation])
}
