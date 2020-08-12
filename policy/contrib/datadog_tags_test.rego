package contrib.datadog

test_required_datadog_tags_with_valid_input {
  production_tags := {
		"ad.datadoghq.com/tags": "{ \"env\": \"production\", \"service\": \"bar\" }"
  }

	required_datadog_tags with input as production_tags

  staging_tags := {
		"ad.datadoghq.com/tags": "{ \"env\": \"production\", \"service\": \"bar\" }"
  }

	required_datadog_tags with input as staging_tags
}

test_required_datadog_tags_with_invalid_env {
	not required_datadog_tags with input as  {
		"ad.datadoghq.com/tags": "{ \"env\": \"junk\", \"service\": \"bar\" }"
  }
}

test_required_datadog_tags_with_missing_env_tag {
	not required_datadog_tags with input as  {
		"ad.datadoghq.com/tags": "{ \"service\": \"bar\" }"
  }

	not required_datadog_tags with input as  {
		"ad.datadoghq.com/tags": "{ \"env\": \"\", \"service\": \"bar\" }"
  }
}

test_required_datadog_tags_with_missing_service_tag {
	not required_datadog_tags with input as  {
		"ad.datadoghq.com/tags": "{ \"env\": \"production\" }"
  }

	not required_datadog_tags with input as  {
		"ad.datadoghq.com/tags": "{ \"env\": \"production\", \"service\": \"\" }"
  }
}

test_required_datadog_tags_with_missing_annotation {
	not required_datadog_tags with input as { }
}
