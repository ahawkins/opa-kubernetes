package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
  input.metadata.namespace
  msg = sprintf("[MTA-01] %s cannot set explicit namespace", [name])
}

required_labels {
	input.metadata.labels["app.kubernetes.io/name"]
	input.metadata.labels["app.kubernetes.io/instance"]
	input.metadata.labels["app.kubernetes.io/version"]
	input.metadata.labels["app.kubernetes.io/component"]
	input.metadata.labels["app.kubernetes.io/part-of"]
	input.metadata.labels["app.kubernetes.io/managed-by"]
}

deny[msg] {
  not required_labels
  msg = sprintf("[MTA-02] %s must include Kubernetes recommended labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels", [name])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	not required_labels with input as template
  msg = sprintf("[MTA-02] %s template must include Kubernetes recommended labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels", [name])
}
