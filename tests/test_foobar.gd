extends GdUnitTestSuite

func test_string_to_lower() -> void:
	assert_str("AbcD".to_lower()).is_equal("abcd")

func test_foo() -> void:
	# do some assertions
	assert_str("").is_empty()
	# last assert was succes
	if is_failure():
		return
