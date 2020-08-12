package main

test_required_liveness_probes_with_valid_data {
	required_liveness_probe with input as [{
		"livenessProbe": "foo"
	}]
}

test_required_liveness_probes_with_invalid_data {
	not required_liveness_probe with input as [{
	}, {
		"livenessProbe": "foo"
	}]
}

test_required_readiness_probes_with_valid_data {
	required_readiness_probe with input as [{
		"readinessProbe": "foo"
	}]
}

test_required_readiness_probes_with_invalid_data {
	not required_readiness_probe with input as [{
	}, {
		"readinessProbe": "foo"
	}]
}
