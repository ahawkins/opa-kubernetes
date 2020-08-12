package main

test_label_selector_rules_on_valid_data {
	input := {
		"spec": {
			"selector": {
				"matchLabels": {
					"app": "dummy",
					"component": "dummy"
				}
			},
			"template": {
				"metadata": {
					"labels": {
						"app": "dummy",
						"component": "dummy",
						"extra": "value"
					}
				}
			}
		}
	}

	matching_label_selector with input as input
	required_label_selector with input as input
}

test_matching_label_selector_with_missing_label {
	not matching_label_selector  with input as {
		"spec": {
			"selector": {
				"matchLabels": {
					"app": "dummy",
					"component": "dummy"
				}
			},
			"template": {
				"metadata": {
					"labels": {
						"app": "dummy"
					}
				}
			}
		}
  }
}

test_matching_label_selector_with_incorrect_value {
	not matching_label_selector with input as {
		"spec": {
			"selector": {
				"matchLabels": {
					"app": "dummy",
					"component": "dummy"
				}
			},
			"template": {
				"metadata": {
					"labels": {
						"app": "dummy",
						"component": "broken"
					}
				}
			}
		}
  }
}

test_requires_label_selector_missing_match_labels {
	not required_label_selector with input as {
		"spec": {
			"selector": {
			},
			"template": {
				"metadata": {
					"labels": {
						"app": "dummy",
						"component": "broken"
					}
				}
			}
		}
  }

	not required_label_selector with input as {
		"spec": {
			"selector": {
				"matchLabels": {

				}
			},
			"template": {
				"metadata": {
					"labels": {
						"app": "dummy",
						"component": "broken"
					}
				}
			}
		}
  }
}

test_matching_label_selector_with_missing_template_label {
	not required_label_selector with input as {
		"spec": {
			"selector": {
				"matchLabels": {
					"app": "dummy",
					"component": "dummy"
				}
			},
			"template": {
				"metadata": {
				}
			}
		}
  }

	not required_label_selector with input as {
		"spec": {
			"selector": {
				"matchLabels": {
					"app": "dummy",
					"component": "dummy"
				}
			},
			"template": {
				"metadata": {
					"labels": {
					}
				}
			}
		}
  }
}
