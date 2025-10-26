extends GdUnitTestSuite


func test_projectile_template_simple() -> void:
	var runner := scene_runner("uid://l1bpiwyep1wq")
	runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_projectile_template_advanced() -> void:
	var runner := scene_runner("uid://bgo83y47tcri0")
	runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_projectile_template_custom() -> void:
	var runner := scene_runner("uid://cj68gunmdf1d2")
	runner.simulate_frames(5)

	assert_object(runner).is_not_null()
	pass

func test_projectile_template_node_2d() -> void:
	var runner := scene_runner("uid://cm72pafj44d6b")
	runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass