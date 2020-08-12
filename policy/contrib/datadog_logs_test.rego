package contrib.datadog

test_unmapped_datadog_log_annotation {
	unmapped_datadog_log_annotation with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/extra.logs": "{ \"source\": \"docker\", \"service\": \"dummy\" }",
				"ad.datadoghq.com/dummy.logs": "{ \"source\": \"docker\", \"service\": \"dummy\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy"
			}]
		}
	}
}

test_unmapped_datadog_log_annotation_with_extra_datadog_annotation {
	not unmapped_datadog_log_annotation with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/dummy.logs": "{ \"source\": \"docker\", \"service\": \"dummy\" }",
				"ad.datadoghq.com/tags": "{ \"foo\": \"bar\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy"
			}]
		}
	}
}

test_required_datadog_container_logging_with_valid_input {
	required_datadog_container_logging with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/dummy.logs": "{ \"source\": \"docker\", \"service\": \"dummy\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy"
			}]
		}
	}
}

test_required_datadog_container_logging_with_unlogged_container {
	not required_datadog_container_logging with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/dummy.logs": "{ \"source\": \"docker\", \"service\": \"dummy\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy"
			}, {
				"name": "broken"
			}]
		}
	}
}

test_required_datadog_container_logging_with_missing_service {
	not required_datadog_container_logging with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/dummy.logs": "{ \"source\": \"docker\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy"
			}]
		}
	}
}

test_required_datadog_container_logging_with_empty_service {
	not required_datadog_container_logging with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/dummy.logs": "{ \"service\": \"\", \"source\": \"docker\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy"
			}]
		}
	}
}

test_required_datadog_container_logging_with_invalid_source {
	not required_datadog_container_logging with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/dummy.logs": "{ \"source\": \"junk\", \"sevice\": \"dummy\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy"
			}]
		}
	}
}

test_required_datadog_container_logging_with_missing_source {
	not required_datadog_container_logging with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/dummy.logs": "{ \"service\": \"dummy\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy",
			}]
		}
	}
}

test_required_datadog_container_logging_with_missing_annotation {
	not required_datadog_container_logging with input as {
		"metadata": {
			"annotations": {
				"ad.datadoghq.com/other.logs": "{ \"source\": \"docker\", \"service\": \"dummy\" }"
			}
		},
		"spec": {
			"containers": [{
				"name": "dummy"
			}]
		}
	}
}
