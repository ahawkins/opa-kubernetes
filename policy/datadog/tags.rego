package datadog

import data.kubernetes

valid_environment_tags := { "production", "staging", "development", "test" }

name = input.metadata.name

required_datadog_tags {
	annotation := input.annotations["ad.datadoghq.com/tags"]
	tags := json.unmarshal(annotation)
	env := tags.env
	valid_environment_tags[tags.env]
	count(tags.service) > 0
}

deny[msg] {
  kubernetes.is_workload
	template := kubernetes.workload_template(input)
	metadata := template.metadata
	not required_datadog_tags with input as metadata
  msg = sprintf("[DOG-01] %s must specify required Datadog tags", [name])
}
