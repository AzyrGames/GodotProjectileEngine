extends GdUnitTestSuite


func test_pattern_composer_simple() -> void:
	var runner := scene_runner("uid://c100r43aw5b57")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_polygon() -> void:
	var runner := scene_runner("uid://dlxrdpvh8mcpu")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_pattern_composer_spread() -> void:
	var runner := scene_runner("uid://dtmk56w332se2")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass
	
func test_pattern_composer_stack() -> void:
	var runner := scene_runner("uid://yypoytt7an8h")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

# func test_projectile_template_advanced() -> void:
# 	var runner := scene_runner("uid://bgo83y47tcri0")
# 	await runner.simulate_frames(5)
# 	assert_object(runner).is_not_null()
# 	pass

# func test_projectile_template_custom() -> void:
# 	var runner := scene_runner("uid://cj68gunmdf1d2")
# 	await runner.simulate_frames(5)

# 	assert_object(runner).is_not_null()
# 	pass

# func test_projectile_template_node_2d() -> void:
# 	var runner := scene_runner("uid://cm72pafj44d6b")
# 	await runner.simulate_frames(5)
# 	assert_object(runner).is_not_null()
# 	pass