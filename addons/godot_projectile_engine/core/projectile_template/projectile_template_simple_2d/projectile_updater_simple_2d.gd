extends ProjectileUpdater2D
class_name ProjectileUpdaterSimple2D

var projectile_velocity : Vector2 = Vector2.ZERO

var projectile_life_time_second_max : float = 10.0
var projectile_life_distance_max : float = 300.0

var destroy_on_body_collide : bool
var destroy_on_area_collide : bool


var projectile_texture_rotate_direction : bool

func init_updater_variable() -> void:
	projectile_template_2d = projectile_template_2d as ProjectileTemplateSimple2D
	projectile_speed = projectile_template_2d.speed
	destroy_on_body_collide = projectile_template_2d.destroy_on_body_collide
	destroy_on_area_collide = projectile_template_2d.destroy_on_area_collide

	_new_projectile_instance = Callable(ProjectileInstanceSimple2D, "new")
	pass


#region Spawn Projectile

func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	for pattern_data : PatternComposerData in pattern_composer_pack:

		_projectile_instance = projectile_instance_array[projectile_pooling_index]
		_projectile_instance.direction = pattern_data.direction
		_projectile_instance.global_position = pattern_data.position
		_projectile_instance.rotation = pattern_data.rotation

		if projectile_texture_rotate_direction:
			_projectile_instance.rotation = _projectile_instance.direction.angle()

		_projectile_instance.velocity = pattern_data.direction * projectile_speed * (1.0 / Engine.physics_ticks_per_second)

		_projectile_instance.transform = Transform2D(
			_projectile_instance.rotation,
			projectile_template_2d.scale,
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
	pass

#endregion


#region Update Projectile

func update_projectile_instances(delta: float) -> void:
	projectile_speed = projectile_template_2d.speed
	projectile_life_time_second_max  = projectile_template_2d.life_time_second_max
	projectile_life_distance_max  = projectile_template_2d.life_distance_max
	projectile_texture_rotate_direction = projectile_template_2d.texture_rotate_direction

	# Check for projectile destroy condition
	for index : int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]

		# Life Time & Distance
		if projectile_life_time_second_max >= 0:
			_projectile_instance.life_time_second += delta
			if _projectile_instance.life_time_second >= projectile_life_time_second_max:
				projectile_remove_index.append(index)
				continue

		if projectile_life_distance_max >= 0:
			_projectile_instance.life_distance += _projectile_instance.velocity.length()
			if _projectile_instance.life_distance >= projectile_life_distance_max:
				projectile_remove_index.append(index)
				continue

		if destroy_on_area_collide:
			if has_overlapping_areas(index):
				for _overlap_area in get_overlapping_areas(index):
					if not _overlap_area.collision_layer & projectile_collision_mask:
						continue
					projectile_remove_index.append(index)

		if destroy_on_body_collide:
			if has_overlapping_bodies(index):
				for _overlap_body in get_overlapping_bodies(index):
					if not _overlap_body.collision_layer & projectile_collision_mask:
						continue
					projectile_remove_index.append(index)

	# Destroy projectile
	if projectile_remove_index.size() > 0:
		for index : int in projectile_remove_index:
			projectile_active_index.erase(index)
			if projectile_template_2d.collision_shape:
				PS.area_set_shape_disabled(projectile_area_rid, index, true)
		projectile_remove_index.clear()

	# Update active projectile instances array
	_active_instances.clear()
	for index : int in projectile_active_index:
		_active_instances.append(projectile_instance_array[index])
	if _active_instances.size() <= 0: return

	# Update active projectile
	for _active_instance : ProjectileInstanceSimple2D in _active_instances:

		_active_instance.global_position += _active_instance.velocity

		_active_instance.transform = Transform2D(
			_active_instance.rotation,
			projectile_template_2d.scale,
			projectile_template_2d.skew,
			_active_instance.global_position
			)

		# if _active_instance.area_rid:
		if projectile_template_2d.collision_shape:
			PS.area_set_shape_transform(
				projectile_area_rid,
				_active_instance.area_index,
				_active_instance.transform
				)

#endregion
