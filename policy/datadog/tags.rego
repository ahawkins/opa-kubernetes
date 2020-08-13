package datadog

import data.datadog_required_tags
import data.kubernetes

name = input.metadata.name

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	not template.metadata.annotations["ad.datadoghq.com/tags"]
	msg = sprintf("[DOG-01] %s must specify Datdog tags annotation", [name])
}

deny[msg] {
	datadog_required_tags
	template := kubernetes.workload_template(input)
	annotation := template.metadata.annotations["ad.datadoghq.com/tags"]
	tags := json.unmarshal(annotation)
	tag := datadog_required_tags[_]
	not tags[tag]
	msg = sprintf("[DOG-01] %s %s must specify the %s tag", [input.kind, name, tag])
}

warn[msg] {
	not datadog_required_tags
	msg = "[DOG-01] missing user provided tags. Refer to docs."
}
