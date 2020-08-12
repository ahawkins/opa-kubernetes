package main

import data.kubernetes

name = input.metadata.name

explicit_namespace {
	input.namespace
}

deny[msg] {
  explicit_namespace with input as input.metadata
  msg = sprintf("%s cannot set explicit namespace", [name])
}
