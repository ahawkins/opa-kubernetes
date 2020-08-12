#!/usr/bin/env basts

setup() {
	run conftest test test/fixtures/pass/horizontal_pod_autoscaler.yml
	[ $status -eq 0 ]
}

@test "HPA-01 - HPA replica sanity" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/horizontal_pod_autoscaler.yml" 'spec.minReplicas' 10
	yq w -i "${fixture}/horizontal_pod_autoscaler.yml" 'spec.maxReplicas' 1

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'HPA-01'
}
