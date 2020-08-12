package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
	kubernetes.is_job
	not input.spec.backoffLimit
	msg = sprintf("[JOB-01] JOb %s must specify backoffLimit", [ name ])
}
