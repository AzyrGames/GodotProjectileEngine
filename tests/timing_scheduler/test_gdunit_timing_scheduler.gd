extends GdUnitTestSuite


func test_timing_scheduler_cooldown() -> void:
	var runner := scene_runner("uid://c3h721cnivuwh")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_timing_scheduler_repeater() -> void:
	var runner := scene_runner("uid://iutp25ib6h50")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass

func test_timing_scheduler_timing_set() -> void:
	var runner := scene_runner("uid://uibs8p43qvxc")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	pass