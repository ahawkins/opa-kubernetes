#!/usr/bin/env basts

setup() {
	run conftest test \
		--combine --namespace combined test/fixtures/pass/*
	[ $status -eq 0 ]
}

@test "SEC-01 - Valid Base64 values" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/secret.yml" 'stringData'
	yq w -i "${fixture}/secret.yml" 'data.FOO' '@#*$&@#$&#@'

	cat "${fixture}/secret.yml"

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'SEC-01'
}
