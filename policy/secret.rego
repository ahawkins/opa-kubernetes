package main

import data.kubernetes

name = input.metadata.name

valid_base64_secret_values {
	valid_values := {
		value |
		some key
		string_value = input[key].value
		re_match("^[-A-Za-z0-9+=]{1,50}|=[^=]|={3,}$", string_value)
		value := string_value
	}

	count(input) == count(valid_values)
}

deny[msg] {
	kubernetes.is_secret
	not valid_base64_secret_values with input as input.data
	msg = sprintf("[SEC-01] Secret %s must specify valid Base64 values", [ name ])
}
