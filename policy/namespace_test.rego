package main

test_denies_entities_with_explicit_namespace {
	explicit_namespace with input as { "name": "dummy", "namespace": "blocked" }
}

test_allows_entities_without_explicit_namespace {
	not explicit_namespace with input as {  "name": "dummy" }
}
