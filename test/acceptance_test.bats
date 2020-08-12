#!/usr/bin/env basts

@test "Valid data passes main package" {
	run conftest test \
		test/fixtures/pass/*
	echo "${output[@]}"
	[ $status -eq 0 ]
}

@test "Valid data passes combined package" {
	run conftest test \
		--combine --namespace combined \
		test/fixtures/pass/*
	echo "${output[@]}"
	[ $status -eq 0 ]
}
