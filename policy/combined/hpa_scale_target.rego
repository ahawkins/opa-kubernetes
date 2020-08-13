package combined

deny[msg] {
	entity := entities[_]
	entity.kind == "HorizontalPodAutoscaler"
	scale_target := entity.spec.scaleTargetRef.name
	not deployments_by_name[scale_target]
	msg = sprintf("[CMB-04] %s %s scaleTargetRef must match a Deployment", [entity.kind, entity.metadata.name])
}

deny[msg] {
	entity := entities[_]
	entity.kind == "HorizontalPodAutoscaler"
	scale_target := entity.spec.scaleTargetRef.name

	deployment := deployments_by_name[scale_target]
	deployment.spec.replicas

	msg = sprintf("[CMB-06] %s Deployment scaled by HPA cannot set replicas", [deployment.metadata.name])
}
