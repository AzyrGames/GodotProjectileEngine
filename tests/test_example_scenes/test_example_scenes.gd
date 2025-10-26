extends GdUnitTestSuite

var runner: GdUnitSceneRunner

func test_example_scene_1() -> void:
	runner = null
	runner = scene_runner("uid://cwlrovd240rt2")
	# runner._scene_auto_free = true

	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass

func test_example_scene_2() -> void:
	runner = null
	runner = scene_runner("uid://b34nudu7t8gwd")
	runner._scene_auto_free = true

	await runner.simulate_frames(10)
	
	assert_object(runner).is_not_null()
	pass

func test_example_scene_3() -> void:
	runner = null
	runner = scene_runner("uid://rxicnemi55bq")
	runner._scene_auto_free = true

	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass
	
func test_example_scene_4() -> void:
	runner = null
	runner = scene_runner("uid://4jgbpsiaa8uu")
	runner._scene_auto_free = true
	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass
	
func test_example_scene_5() -> void:
	runner = null
	runner = scene_runner("uid://bccgqsjl1b74f")
	runner._scene_auto_free = true

	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass
	
func test_example_scene_6() -> void:
	runner = null
	runner = scene_runner("uid://dactafr7x6iw3")
	runner._scene_auto_free = true

	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass
	
