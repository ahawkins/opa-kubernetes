package kubernetes

valid_environments := { "production", "staging" }

workload_kinds := { "Deployment", "Job" }

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
