extends ProjectileUpdater2D
class_name ProjectileUpdaterSimple2D

var projectile_velocity: Vector2 = Vector2.ZERO

var projectile_life_time_second_max: float = 10.0
var projectile_life_distance_max: float = 300.0

var destroy_on_body_collide: bool
var destroy_on_area_collide: bool


var projectile_texture_rotate_direction: bool

func init_updater_variable() -> void:
	projectile_speed = projectile_template_2d.speed
	destroy_on_body_collide = projectile_template_2d.destroy_on_body_collide
	destroy_on_area_collide = projectile_template_2d.destroy_on_area_collide

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

func update_projectile_instances(delta: float) -> void:
	projectile_speed = projectile_template_2d.speed
	projectile_life_time_second_max = projectile_template_2d.life_time_second_max
	projectile_life_distance_max = projectile_template_2d.life_distance_max
	projectile_texture_rotate_direction = projectile_template_2d.texture_rotate_direction
	var _overlap_collision_layer : int 

	# Check for projectile destroy condition
	for index: int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]
		# Life Time & Distance
		if _projectile_instance.life_time_second_max >= 0:
			_projectile_instance.life_time_second += delta
			if _projectile_instance.life_time_second >= _projectile_instance.life_time_second_max:
				projectile_remove_index.append(index)
				continue

		if _projectile_instance.life_distance_max >= 0:
			_projectile_instance.life_distance += _projectile_instance.velocity.length()
			if _projectile_instance.life_distance >= _projectile_instance.life_distance_max:
				projectile_remove_index.append(index)
				continue

		if destroy_on_area_collide:
			if has_overlapping_areas(index):
				for _overlap_area in get_overlapping_areas(index):
					# if !ProjectileEngine: return
					_overlap_collision_layer = ProjectileEngine.get_collider_collision_layer(_overlap_area)
					if not _overlap_collision_layer & projectile_collision_mask:
						continue
					projectile_remove_index.append(index)

		if destroy_on_body_collide:
			if has_overlapping_bodies(index):
				for _overlap_body in get_overlapping_bodies(index):
					# print("ProjectileEngine ProjectileEngine: ", ProjectileEngine)
					# print(_overlap_body)
					if !_overlap_body:
						get_overlapping_bodies(index).erase(_overlap_body)
						continue
					_overlap_collision_layer = ProjectileEngine.get_collider_collision_layer(_overlap_body)
					if !_overlap_collision_layer & projectile_collision_mask:
						continue
					projectile_remove_index.append(index)

	# Destroy projectile
	if projectile_remove_index.size() > 0:
		for index: int in projectile_remove_index:
			projectile_active_index.erase(index)
			if projectile_template_2d.collision_shape:
				PS.area_set_shape_disabled(projectile_area_rid, index, true)
		projectile_remove_index.clear()

	# Update active projectile instances array
	_active_projectile_instances.clear()
	for index: int in projectile_active_index:
		_active_projectile_instances.append(projectile_instance_array[index])
	if _active_projectile_instances.size() <= 0: return

	# Update active projectile
	for _active_projectile_instance: ProjectileInstanceSimple2D in _active_projectile_instances:
		_active_projectile_instance.global_position += _active_projectile_instance.velocity

		_active_projectile_instance.transform = Transform2D(
			_active_projectile_instance.texture_rotation,
			_active_projectile_instance.scale,
			_active_projectile_instance.skew,
			_active_projectile_instance.global_position
			)

		# if _active_projectile_instance.area_rid:
		if projectile_template_2d.collision_shape:
			PS.area_set_shape_transform(
				projectile_area_rid,
				_active_projectile_instance.area_index,
				_active_projectile_instance.transform
				)

#endregion
