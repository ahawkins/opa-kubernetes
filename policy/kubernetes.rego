package kubernetes

workload_kinds := {"Deployment", "Job", "CronJob"}

is_service {
	input.kind = "Service"
}

is_deployment {
	input.kind = "Deployment"
}

is_hpa {
	input.kind = "HorizontalPodAutoscaler"
}

is_secret {
	input.kind = "Secret"
}

is_job {
	input.kind = "Job"
}

is_workload {
	workload_kinds[input.kind]
}

workload_template(entity) = template {
	template := entity.spec.template
}

workload_template(entity) = template {
	template := entity.spec.jobTemplate.spec.template
}
