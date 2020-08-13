#!/usr/bin/env basts

setup() {
	run conftest test test/fixtures/pass/secret.yml
	[ $status -eq 0 ]
}

@test "SEC-01 - Valid Base64 values" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/secret.yml" 'stringData'
	yq w -i "${fixture}/secret.yml" 'data.FOO' '@#*$&@#$&#@'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'SEC-01'
}
