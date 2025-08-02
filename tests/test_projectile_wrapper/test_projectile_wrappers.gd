extends GdUnitTestSuite


func test_projectile_template_simple() -> void:
	var runner := scene_runner("uid://uf11mp6p4ldp")
	await runner.simulate_frames(5)
	assert_object(runner).is_not_null()
	ProjectileEngine.activate_all_projectile_wrappers("")
	ProjectileEngine.activate_all_projectile_wrappers("wrong_wrapper")
	ProjectileEngine.deactivate_all_projectile_wrappers("test_wrapper_node_1")
	for _projectile_wrapper_node : ProjectileWrapper2D in ProjectileEngine.projectile_wrapper_2d_nodes.get("test_wrapper_node_1"):
		assert_bool(_projectile_wrapper_node.active).is_false()
	ProjectileEngine.activate_all_projectile_wrappers("test_wrapper_node_1")
	for _projectile_wrapper_node : ProjectileWrapper2D in ProjectileEngine.projectile_wrapper_2d_nodes.get("test_wrapper_node_1"):
		assert_bool(_projectile_wrapper_node.active).is_true()
	