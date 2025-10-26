extends GdUnitTestSuite

var runner: GdUnitSceneRunner

func test_example_scene_1() -> void:
	runner = null
	var _scene : Node2D = load("uid://cwlrovd240rt2").instantiate()
	## Workaround for A problem
	_scene.process_mode = Node.PROCESS_MODE_DISABLED
	runner = scene_runner(_scene)
	runner._scene_auto_free = true

	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass

func test_example_scene_2() -> void:
	var _scene : Node2D = load("uid://b34nudu7t8gwd").instantiate()
	_scene.process_mode = Node.PROCESS_MODE_DISABLED

	runner = null
	runner = scene_runner(_scene)
	runner._scene_auto_free = true

	await runner.simulate_frames(10)
	
	assert_object(runner).is_not_null()
	pass

func test_example_scene_3() -> void:
	runner = null
	var _scene : Node2D = load("uid://rxicnemi55bq").instantiate()
	_scene.process_mode = Node.PROCESS_MODE_DISABLED

	runner = scene_runner(_scene)
	runner._scene_auto_free = true
	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass
	
func test_example_scene_4() -> void:
	var _scene : Node2D = load("uid://4jgbpsiaa8uu").instantiate()
	_scene.process_mode = Node.PROCESS_MODE_DISABLED

	runner = null
	runner = scene_runner(_scene)
	runner._scene_auto_free = true
	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass
	
func test_example_scene_5() -> void:
	var _scene : Node2D = load("uid://bccgqsjl1b74f").instantiate()
	_scene.process_mode = Node.PROCESS_MODE_DISABLED

	runner = null
	runner = scene_runner(_scene)
	runner._scene_auto_free = true
	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass
	
func test_example_scene_6() -> void:
	var _scene : Node2D = load("uid://dactafr7x6iw3").instantiate()
	_scene.process_mode = Node.PROCESS_MODE_DISABLED

	runner = null
	runner = scene_runner(_scene)
	runner._scene_auto_free = true

	await runner.simulate_frames(10)
	assert_object(runner).is_not_null()
	pass
	
