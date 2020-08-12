#!/usr/bin/env basts

setup() {
	run conftest test test/fixtures/pass/deployment.yml test/fixtures/pass/job.yml
	[ $status -eq 0 ]
}

@test "WRK-01 - Deployment containers set resource requests" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].resources.requests'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'WRK-01'
}

@test "WRK-01 - Deployment containers set resource limits" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].resources.limits'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'WRK-01'
}

@test "WRK-01 - Job containers set resource requests" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.template.spec.containers[0].resources.requests'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'WRK-01'
}

@test "WRK-01 - Job containers set resource limits" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.template.spec.containers[0].resources.limits'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'WRK-01'
}

@test "WRK-02 - Deployment containers volume mount" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].volumeMounts[0].name' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'WRK-02'
}

@test "WRK-02 - Job containers volume mount" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.spec.containers[0].volumeMounts[0].name' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'WRK-02'
}

@test "WRK-03 - Deployment unmounted volume" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.volumes[+].name' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'WRK-03'
}

@test "WRK-03 - Job unmounted volume" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.spec.volumes[+].name' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'WRK-03'
}
