package main

test_resources_missing_requests {
	not required_resources with input as {"resources": {"limits": {"cpu": 1, "memory": "1024Mi"}}}

	not required_resources with input as {"resources": {
		"requests": {"memory": "1024Mi"},
		"limits": {"cpu": 1, "memory": "1024Mi"},
	}}

	not required_resources with input as {"resources": {
		"requests": {"cpu": 1},
		"limits": {"cpu": 1, "memory": "1024Mi"},
	}}
}

test_resources_missing_limits {
	not required_resources with input as {"resources": {"requests": {"cpu": 1, "memory": "1024Mi"}}}

	not required_resources with input as {"resources": {
		"limits": {"memory": "1024Mi"},
		"requests": {"cpu": 1, "memory": "1024Mi"},
	}}

	not required_resources with input as {"resources": {
		"limits": {"cpu": 1},
		"requests": {"cpu": 1, "memory": "1024Mi"},
	}}
}

test_resources_using_string_cpu {
	not required_resources with input as {"resources": {
		"requests": {"cpu": "500m", "memory": "1024Mi"},
		"limits": {"cpu": 1, "memory": "2048Mi"},
	}}

	not required_resources with input as {"resources": {
		"requests": {"cpu": 0.5, "memory": "1024Mi"},
		"limits": {"cpu": "1m", "memory": "2048Mi"},
	}}
}

test_resources_using_numeric_memory {
	not required_resources with input as {"resources": {
		"requests": {"cpu": 0.5, "memory": 1024},
		"limits": {"cpu": 1, "memory": "2048Mi"},
	}}

	not required_resources with input as {"resources": {
		"requests": {"cpu": 0.5, "memory": "1024Mi"},
		"limits": {"cpu": 1, "memory": 2048},
	}}
}

test_resources_memory_units {
	# Mi OK
	required_resources with input as {"resources": {
		"requests": {"cpu": 0.5, "memory": "1024Mi"},
		"limits": {"cpu": 1, "memory": "2048Mi"},
	}}

	# Gi OK
	required_resources with input as {"resources": {
		"requests": {"cpu": 0.5, "memory": "1Gi"},
		"limits": {"cpu": 1, "memory": "2Gi"},
	}}

	# Other units not allowed
	not required_resources with input as {"resources": {
		"requests": {"cpu": 0.5, "memory": "1m"},
		"limits": {"cpu": 1, "memory": "2m"},
	}}
}

test_resources_requests_more_than_limits {
	# cpu
	not required_resources with input as {"resources": {
		"requests": {"cpu": 2000, "memory": "1024Mi"},
		"limits": {"cpu": 1, "memory": "2048Mi"},
	}}

	# memory
	not required_resources with input as {"resources": {
		"requests": {"cpu": 500, "memory": "2048Mi"},
		"limits": {"cpu": 1, "memory": "1024Mi"},
	}}
}
