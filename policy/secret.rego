package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
	kubernetes.is_secret
	some key
	encoded_value := input.data[key]
	not re_match("^[-A-Za-z0-9+=]{1,50}|=[^=]|={3,}$", encoded_value)
	msg = sprintf("[SEC-01] Secret %s data key %s must be Base64 encoded", [name, key])
}
