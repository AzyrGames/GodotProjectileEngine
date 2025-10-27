extends ProjectileUpdater2D
class_name ProjectileUpdaterSimple2D

var projectile_velocity: Vector2 = Vector2.ZERO

var projectile_life_time_second_max: float = 10.0
var projectile_life_distance_max: float = 300.0

var destroy_on_body_collide: bool
var destroy_on_area_collide: bool


var projectile_texture_rotate_direction: bool

func init_updater_variable() -> void:
	super ()
	projectile_template_2d = projectile_template_2d as ProjectileTemplateSimple2D

	projectile_speed = projectile_template_2d.speed
	destroy_on_body_collide = projectile_template_2d.destroy_on_body_collide
	destroy_on_area_collide = projectile_template_2d.destroy_on_area_collide

	projectile_life_time_second_max = projectile_template_2d.life_time_second_max
	projectile_life_distance_max = projectile_template_2d.life_distance_max

	_new_projectile_instance = Callable(ProjectileInstanceSimple2D, "new")

#region Spawn Projectile

func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	projectile_template_2d = projectile_template_2d as ProjectileTemplateSimple2D
	for _pattern_composer_data: PatternComposerData in pattern_composer_pack:
		_projectile_instance = projectile_instance_array[projectile_pooling_index]

		_projectile_instance.global_position = _pattern_composer_data.position
		_projectile_instance.direction = _pattern_composer_data.direction
		_projectile_instance.direction_rotation = _pattern_composer_data.direction_rotation
		_projectile_instance.texture_rotation = projectile_template_2d.texture_rotation
		_projectile_instance.scale = projectile_template_2d.scale
		_projectile_instance.life_time_second_max = projectile_template_2d.life_time_second_max
		_projectile_instance.life_distance_max = projectile_template_2d.life_distance_max
		
		# Check and update random variables
		var _speed_value: float = projectile_speed
		var _scale_value_float: float
		var _scale_value: Vector2 = projectile_template_2d.scale
		var _rotation_value: float = _projectile_instance.texture_rotation

		if projectile_template_2d.speed_random != Vector3.ZERO:
			_speed_value = ProjectileEngine.get_random_float_value(projectile_template_2d.speed_random)
		if projectile_template_2d.scale_random != Vector3.ZERO:
			_scale_value_float = ProjectileEngine.get_random_float_value(projectile_template_2d.scale_random)
			_scale_value = Vector2(_scale_value_float, _scale_value_float)
			_projectile_instance.scale = _scale_value
			
		if projectile_template_2d.texture_rotation_random != Vector3.ZERO:
			_projectile_instance.texture_rotation = ProjectileEngine.get_random_float_value(
				projectile_template_2d.texture_rotation_random
				)
		if projectile_template_2d.life_time_second_random != Vector3.ZERO:
			_projectile_instance.life_time_second_max = ProjectileEngine.get_random_float_value(
				projectile_template_2d.life_time_second_random
				)
		if projectile_template_2d.life_distance_random != Vector3.ZERO:
			_projectile_instance.life_distance_max = ProjectileEngine.get_random_float_value(
				projectile_template_2d.life_distance_random
				)
	
		_projectile_instance.direction = _projectile_instance.direction.rotated(
			_projectile_instance.direction_rotation
			)

		_projectile_instance.velocity = (
			_projectile_instance.direction * _speed_value *
			(1.0 / Engine.physics_ticks_per_second)
			)

		if projectile_texture_rotate_direction:
			_projectile_instance.texture_rotation = _projectile_instance.direction.angle()

		_projectile_instance.transform = Transform2D(
			_projectile_instance.texture_rotation,
			_projectile_instance.scale,
			projectile_template_2d.skew,
			_projectile_instance.global_position
			)

		RenderingServer.canvas_item_set_visible(_projectile_instance.canvas_item_rid, true)
		RenderingServer.canvas_item_set_transform(_projectile_instance.canvas_item_rid, _projectile_instance.transform)


		if projectile_template_2d.collision_shape:
			PS.area_set_shape_transform(projectile_area_rid, projectile_pooling_index, _projectile_instance.transform)
			PS.area_set_shape_disabled(projectile_area_rid, projectile_pooling_index, false)

		_projectile_instance.life_time_second = 0.0
		_projectile_instance.life_distance = 0.0

		projectile_instance_array[projectile_pooling_index] = _projectile_instance
		if projectile_pooling_index not in projectile_active_index:
			projectile_active_index.append(projectile_pooling_index)
		projectile_pooling_index += 1

		if projectile_pooling_index >= projectile_max_pooling:
			projectile_pooling_index = 0

#endregion


#region Update Projectile

var _overlap_collision_layer: int
var _active_projectile_instance: ProjectileInstanceSimple2D
# var _velocity_length: float

func update_projectile_instances(delta: float) -> void:
	# Check for projectile destroy condition
	for index: int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]
		# Life Time & Distance
		if projectile_life_time_second_max > 0:
			_projectile_instance.life_time_second += delta
			if _projectile_instance.life_time_second >= projectile_life_time_second_max:
				projectile_remove_index.append(index)

		if projectile_life_distance_max > 0:
			_projectile_instance.life_distance += _projectile_instance.velocity_length
			if _projectile_instance.life_distance >= projectile_life_distance_max:
				projectile_remove_index.append(index)
				continue

		if destroy_on_area_collide:
			if has_overlapping_areas(index):
				projectile_remove_index.append(index)

		if destroy_on_body_collide:
			if has_overlapping_bodies(index):
				projectile_remove_index.append(index)


		## Update Transform and texture
		_projectile_instance.global_position += _projectile_instance.velocity

		_projectile_instance.transform = Transform2D(
			_projectile_instance.texture_rotation,
			_projectile_instance.scale,
			_projectile_instance.skew,
			_projectile_instance.global_position
			)

		RenderingServer.canvas_item_set_transform(
			projectile_canvas_item_ids[index],
			_projectile_instance.transform
			)

		if projectile_template_2d.collision_shape:
			PS.area_set_shape_transform(
				projectile_area_rid,
				_projectile_instance.area_index,
				_projectile_instance.transform
				)

	# Destroy projectile
	if projectile_remove_index.size() > 0:
		for index: int in projectile_remove_index:
			projectile_active_index.erase(index)
			RenderingServer.canvas_item_set_visible(projectile_instance_array[index].canvas_item_rid, false)
			if projectile_template_2d.collision_shape:
				PS.area_set_shape_disabled(projectile_area_rid, index, true)
		projectile_remove_index.clear()

#endregion

func _on_projectile_template_changed() -> void:
	super ()
	projectile_speed = projectile_template_2d.speed
	projectile_life_time_second_max = projectile_template_2d.life_time_second_max
	projectile_life_distance_max = projectile_template_2d.life_distance_max
	projectile_texture_rotate_direction = projectile_template_2d.texture_rotate_direction

	projectile_life_time_second_max = projectile_template_2d.life_time_second_max
	projectile_life_distance_max = projectile_template_2d.life_distance_max

	for index in projectile_active_index:
		_active_projectile_instance = projectile_instance_array[index]
		_active_projectile_instance.velocity = (
			projectile_speed *
			_active_projectile_instance.direction *
			(1.0 / Engine.physics_ticks_per_second)
			)
		_active_projectile_instance.velocity_length = _projectile_instance.velocity.length()
