package combined

matching_service_selector {
	deployment_selectors := {
		[ label, value ] |
		some deployment, label
		value := input.deployments[deployment].spec.template.metadata.labels[label]
	 }

	service_selector := {
		[ label, value ] |
		some label
		value := input.service.spec.selector[label]
	}

	count(service_selector - deployment_selectors) == 0
}


deny[msg] {
	deployments := { deployment | deployment := deployments_by_name[_] }

	service := services_by_name[_]
	not matching_service_selector with input.service as service with input.deployments as deployments
	msg = sprintf("[CMB-03] Service %s selector must match a Deployment", [ service.metadata.name ])
}

matching_service_port {
	target_ports := { port | port := input.service.spec.ports[_].targetPort }
	container_ports := { port | port := input.deployments[_].spec.template.spec.containers[_].ports[_].containerPort }
	count(target_ports - container_ports) == 0
}

deny[msg] {
	deployments := { deployment | deployment := deployments_by_name[_] }

	service := services_by_name[_]
	not matching_service_port with input.service as service with input.deployments as deployments
	msg = sprintf("[CMB-05] Service %s port must match container port", [ service.metadata.name ])
}
