#!/usr/bin/env basts

setup() {
	run conftest test \
		--combine --namespace combined test/fixtures/pass/*
	[ $status -eq 0 ]
}

@test "CMB-01 - Deployment container ConfigMap" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_configmap_reference.yml \
		"${fixture}/deployment.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-01'
}

@test "CMB-01 - Deployment container Secret" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_secret_reference.yml \
		"${fixture}/deployment.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-01'
}

@test "CMB-01 - Job container ConfigMap" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_configmap_reference.yml \
		"${fixture}/job.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-01'
}

@test "CMB-01 - Job container envFrom Secret" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_secret_reference.yml \
		"${fixture}/job.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-01'
}

@test "CMB-02 - Deployment volume from ConfigMap" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_configmap_volume.yml \
		"${fixture}/deployment.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-02'
}

@test "CMB-02 - Deployment volume from Secret" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_secret_volume.yml \
		"${fixture}/deployment.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-02'
}

@test "CMB-02 - Job volume from ConfigMap" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_configmap_volume.yml \
		"${fixture}/job.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-02'
}

@test "CMB-02 - Job volume from Secret" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_secret_volume.yml \
		"${fixture}/job.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-02'
}

@test "CMB-03 - Service selector matches Deployment labels" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/service.yml" 'spec.selector.app' junk

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-03'
}

@test "CMB-04 - HPA scale target matches Deployment" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/horizontal_pod_autoscaler.yml" 'spec.scaleTargetRef.name' junk

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-04'
}

@test "CMB-05 - Service port matches container port" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/service.yml" 'spec.ports[0].targetPort' 9999

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-05'
}

@test "CMB-06 - HPA Deployment replicas" {
	fixture="$(mktemp -d)"
	cp -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.replicas' 3

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'CMB-06'
}
