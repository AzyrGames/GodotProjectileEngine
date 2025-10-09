extends GdUnitTestSuite


func test_pattern_composer_single() -> void:
	var runner := scene_runner("uid://c100r43aw5b57")
	runner.simulate_frames(5)
	runner._scene_auto_free = false
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_polygon() -> void:
	var runner := scene_runner("uid://dlxrdpvh8mcpu")
	runner.simulate_frames(5)
	runner._scene_auto_free = false
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_spread() -> void:
	var runner := scene_runner("uid://dtmk56w332se2")
	runner.simulate_frames(5)
	runner._scene_auto_free = false
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_stack() -> void:
	var runner := scene_runner("uid://yypoytt7an8h")
	runner.simulate_frames(5)
	runner._scene_auto_free = false
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_shape_2d() -> void:
	var runner := scene_runner("uid://vnh02vjautdp")
	runner.simulate_frames(5)
	runner._scene_auto_free = false
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_custom_shape_2d() -> void:
	var runner := scene_runner("uid://s3visbj8dq43")
	runner.simulate_frames(5)
	runner._scene_auto_free = false
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_loop() -> void:
	var runner := scene_runner("uid://vuaj15gpwguh")
	runner._scene_auto_free = false
	runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_group() -> void:
	var runner := scene_runner("uid://crdq3kd2tjy82")
	runner.simulate_frames(5)
	runner._scene_auto_free = false
	assert_object(runner).is_not_null()
	pass
