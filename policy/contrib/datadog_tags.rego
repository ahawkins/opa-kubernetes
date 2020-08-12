package contrib.datadog

import data.kubernetes

name = input.metadata.name

required_datadog_tags {
	annotation := input["ad.datadoghq.com/tags"]
	tags := json.unmarshal(annotation)
	env := tags.env
	data.kubernetes.valid_environments[tags.env]
	count(tags.service) > 0
}

deny[msg] {
  kubernetes.is_deployment
	not required_datadog_tags with input as input.spec.template.metadata.annotations
  msg = sprintf("%s must specify required Datadog tags", [name])
}
