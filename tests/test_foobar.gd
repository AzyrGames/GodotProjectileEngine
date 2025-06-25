extends GdUnitTestSuite

func test_string_to_lower() -> void:
	assert_str("AbcD".to_lower()).is_equal("abcd")

func test_foo():
	# do some assertions
	assert_str("").is_empty()
	# last assert was succes
	if is_failure():
		return
	assert_str("abc").is_empty()
	# last assert was failure, now abort the test here
	if is_failure():
		return
