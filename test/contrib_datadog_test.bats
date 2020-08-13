#!/usr/bin/env basts

setup() {
	run conftest test --namespace contrib.datadog test/fixtures/pass_datadog/*
	[ $status -eq 0 ]
}

@test "DOG-01 - Deployment tags" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass_datadog/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations'

	run conftest test --namespace contrib.datadog "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DOG-01'
}
