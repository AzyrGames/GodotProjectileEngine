extends GdUnitTestSuite

var runner: GdUnitSceneRunner

func test_pattern_composer_single() -> void:
	runner = null
	runner = scene_runner("uid://c100r43aw5b57")
	await runner.simulate_frames(10)
	runner._scene_auto_free = true
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_polygon() -> void:
	runner = null
	runner = scene_runner("uid://dlxrdpvh8mcpu")
	await runner.simulate_frames(10)
	runner._scene_auto_free = true
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_spread() -> void:
	runner = null
	runner = scene_runner("uid://dtmk56w332se2")
	await runner.simulate_frames(10)
	runner._scene_auto_free = true
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_stack() -> void:
	runner = null
	runner = scene_runner("uid://yypoytt7an8h")
	await runner.simulate_frames(10)
	runner._scene_auto_free = true
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_shape_2d() -> void:
	runner = null
	runner = scene_runner("uid://vnh02vjautdp")
	await runner.simulate_frames(10)
	runner._scene_auto_free = true
	assert_object(runner).is_not_null()

	pass

func test_pattern_composer_custom_shape_2d() -> void:
	runner = null
	runner = scene_runner("uid://s3visbj8dq43")
	await runner.simulate_frames(10)
	runner._scene_auto_free = true
	assert_object(runner).is_not_null()

	pass

func test_pattern_composer_loop() -> void:
	runner = null
	runner = scene_runner("uid://vuaj15gpwguh")
	runner._scene_auto_free = true
	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()

	pass

func test_pattern_composer_group() -> void:
	runner = null
	runner = scene_runner("uid://crdq3kd2tjy82")
	await runner.simulate_frames(10)
	runner._scene_auto_free = true
	assert_object(runner).is_not_null()
	pass