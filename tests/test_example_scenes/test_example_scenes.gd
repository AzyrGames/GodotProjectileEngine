extends GdUnitTestSuite

func test_example_scene_1() -> void:
	var runner := scene_runner("uid://cwlrovd240rt2")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_example_scene_2() -> void:
	var runner := scene_runner("uid://b34nudu7t8gwd")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_example_scene_3() -> void:
	var runner := scene_runner("uid://rxicnemi55bq")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass
    
func test_example_scene_4() -> void:
	var runner := scene_runner("uid://4jgbpsiaa8uu")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass
    
func test_example_scene_5() -> void:
	var runner := scene_runner("uid://bccgqsjl1b74f")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass
    
func test_example_scene_6() -> void:
	var runner := scene_runner("uid://dactafr7x6iw3")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass
    