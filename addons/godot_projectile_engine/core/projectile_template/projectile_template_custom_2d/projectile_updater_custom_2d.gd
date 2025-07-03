extends ProjectileUpdater2D
class_name ProjectileUpdaterCustom2D

var projectile_damage: float = 1.0

var projectile_rotation_speed : float

var behavior_static_context : Dictionary
var behavior_dynamic_context : Dictionary
var behavior_persist_context : Dictionary

var projectile_behavior_context : Dictionary
var projectile_behaviors : Array[ProjectileBehavior] = []

func init_updater_variable() -> void:
	projectile_damage = projectile_template_2d.damage
	projectile_speed = projectile_template_2d.speed
	projectile_template_2d = projectile_template_2d as ProjectileTemplateCustom2D
	_new_projectile_instance = Callable(ProjectileInstanceCustom2D, "new")
	pass


#region Spawn Projectile 

func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	for pattern_data : PatternComposerData in pattern_composer_pack:

		_projectile_instance = projectile_instance_array[projectile_pooling_index]

		_projectile_instance.global_position = pattern_data.position
		_projectile_instance.speed = projectile_speed
		_projectile_instance.base_speed = projectile_speed
		_projectile_instance.direction = pattern_data.direction
		_projectile_instance.base_direction = pattern_data.direction
		_projectile_instance.scale = projectile_template_2d.scale

		_projectile_instance.velocity = _projectile_instance.direction * projectile_speed * (1.0 / Engine.physics_ticks_per_second)

		_projectile_instance.transform = Transform2D(
			projectile_template_2d.rotation, 
			projectile_template_2d.scale,
			projectile_template_2d.skew,
			_projectile_instance.global_position
			)

		PS.area_set_shape_transform(projectile_area_rid, projectile_pooling_index, _projectile_instance.transform)
		PS.area_set_shape_disabled(projectile_area_rid, projectile_pooling_index, false)
	
		_projectile_instance.life_time_second = 0.0
		_projectile_instance.life_distance = 0.0

		_projectile_instance.trigger_count = 0

		projectile_instance_array[projectile_pooling_index] = _projectile_instance

		if projectile_pooling_index not in projectile_active_index:
			projectile_active_index.append(projectile_pooling_index)


		projectile_pooling_index += 1
		
		if projectile_pooling_index >= projectile_max_pooling:
			projectile_pooling_index = 0

#endregion


#region Update Projectile

func update_projectile_instances(delta: float) -> void:
	projectile_damage = projectile_template_2d.damage
	projectile_speed = projectile_template_2d.speed

	projectile_behaviors.clear()
	projectile_behaviors.append_array(projectile_template_2d.speed_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.direction_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.rotation_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.scale_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.destroy_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.homing_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.bouncing_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.piercing_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.trigger_projectile_behaviors)

	var _behavior_requests_contexts : Array[ProjectileEngine.BehaviorContext]
	var _behavior_requests_persist_contexts : Array[ProjectileEngine.BehaviorContext]

	for _projectile_behvior in projectile_behaviors:
		if !_projectile_behvior: continue
		if !_projectile_behvior.active: continue
		_behavior_requests_contexts.append_array(_projectile_behvior._request_behavior_context())
		_behavior_requests_persist_contexts.append_array(_projectile_behvior._request_persist_behavior_context())

	projectile_behavior_context.clear()

	
	# Check for projectile destroy condition
	for index : int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]
		
		_projectile_instance.life_time_second += delta
		_projectile_instance.life_distance += _projectile_instance.velocity.length()
		_projectile_instance.behavior_context.clear()
		_projectile_instance.behavior_update_context.clear()
		process_behavior_context_request(_projectile_instance.behavior_update_context, _projectile_instance, _behavior_requests_contexts)
		process_behavior_context_request(_projectile_instance.behavior_persist_context, _projectile_instance, _behavior_requests_persist_contexts)
		_projectile_instance.behavior_context.merge(_projectile_instance.behavior_update_context)
		_projectile_instance.behavior_context.merge(_projectile_instance.behavior_persist_context)

		for _projectile_behvior in projectile_behaviors:
			if _projectile_behvior is ProjectileBehaviorDestroy:
				if _projectile_behvior.process_behavior(null, _projectile_instance.behavior_context):
					projectile_remove_index.append(index)

		for _behavior_key in _projectile_instance.behavior_context.keys():
			if _behavior_key == ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
				for _behavior_variable in _projectile_instance.behavior_context.get(_behavior_key):
					if _behavior_variable is not BehaviorVariable: continue
					_behavior_variable.is_processed = false


	# Destroy projectile
	if projectile_remove_index.size() > 0:
		for index : int in projectile_remove_index:
			projectile_active_index.erase(index)
			PS.area_set_shape_disabled(projectile_area_rid, index, true)
		projectile_remove_index.clear()

	# Update active projectile instances array
	_active_instances.clear()
	for index : int in projectile_active_index:
		_active_instances.append(projectile_instance_array[index])
	if _active_instances.size() <= 0: return
	# Update active projectile
	
	for _active_instance : ProjectileInstanceCustom2D in _active_instances:

		for _projectile_behvior in projectile_behaviors:
			if _projectile_behvior is ProjectileBehaviorSpeed:
				_active_instance.speed = _projectile_behvior.process_behavior(_active_instance.speed, _active_instance.behavior_context)
			elif _projectile_behvior is ProjectileBehaviorDirection:
				var _new_direction_array: Array
				_new_direction_array = _projectile_behvior.process_behavior(_active_instance.direction, _active_instance.behavior_context)
				if _new_direction_array[0] != _active_instance.direction:
					_active_instance.raw_direction = _new_direction_array[0]
					_active_instance.direction = _active_instance.raw_direction.normalized()

				if _new_direction_array.size() == 2:
					_active_instance.direction_rotation = _new_direction_array[1]

				if _new_direction_array.size() == 3:
					_active_instance.direction_addition = _new_direction_array[2]

			elif _projectile_behvior is ProjectileBehaviorScale:
				_active_instance.scale = _projectile_behvior.process_behavior(_active_instance.scale, _active_instance.behavior_context)
			elif _projectile_behvior is ProjectileBehaviorRotation:
				_active_instance.rotation = _projectile_behvior.process_behavior(_active_instance.rotation, _active_instance.behavior_context)
			elif _projectile_behvior is ProjectileBehaviorHoming:
				# _active_instance.speed = _projectile_behvior.process_behavior(_active_instance.speed, _active_instance.behavior_context)
				var _homing_result: Array = _projectile_behvior.process_behavior(_active_instance.direction, _active_instance.behavior_context)
		
				if _homing_result.size() > 0 and _homing_result[0] != _active_instance.direction:
					# Apply the new direction from homing behavior
					_active_instance.raw_direction = _homing_result[0]
					_active_instance.direction = _active_instance.raw_direction.normalized()
		
			elif _projectile_behvior is ProjectileBehaviorSpeed:
				_active_instance.speed = _projectile_behvior.process_behavior(_active_instance.speed, _active_instance.behavior_context)

		_active_instance.direction_final = _active_instance.direction
		if _active_instance.direction_addition != Vector2.ZERO:
			_active_instance.direction_final = (_active_instance.direction_final + _active_instance.direction_addition).normalized()
		if _active_instance.direction_rotation != 0.0:
			_active_instance.direction_final = _active_instance.base_direction.normalized().rotated(_active_instance.direction_rotation)

		_active_instance.direction = _active_instance.direction_final

		_active_instance.velocity = _active_instance.speed * _active_instance.direction * delta
		_active_instance.global_position += _active_instance.velocity

		_active_instance.transform = Transform2D(
			_active_instance.rotation,
			_active_instance.scale,
			0.0,
			_active_instance.global_position
			)

		PS.area_set_shape_transform(projectile_area_rid, _active_instance.area_index, _active_instance.transform)


func update_projectile_behavior_context() -> void:
	pass


func process_behavior_context_request(_current_context: Dictionary, _projectile_instance: ProjectileInstanceCustom2D, _behavior_contexts: Array[ProjectileEngine.BehaviorContext]) -> void:
	for _behavior_context in _behavior_contexts:
		match _behavior_context:
			ProjectileEngine.BehaviorContext.PHYSICS_DELTA:
				_current_context.get_or_add(_behavior_context, get_physics_process_delta_time())

			ProjectileEngine.BehaviorContext.GLOBAL_POSITION:
				_current_context.get_or_add(_behavior_context, _projectile_instance.global_position)

			ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND:
				_current_context.get_or_add(_behavior_context, _projectile_instance.life_time_second)

			ProjectileEngine.BehaviorContext.LIFE_DISTANCE:
				_current_context.get_or_add(_behavior_context, _projectile_instance.life_distance)

			ProjectileEngine.BehaviorContext.BASE_SPEED:
				_current_context.get_or_add(_behavior_context, _projectile_instance.base_speed)

			ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
				_current_context.get_or_add(_behavior_context, [])

			ProjectileEngine.BehaviorContext.DIRECTION:
				_current_context.get_or_add(_behavior_context, _projectile_instance.direction)

			ProjectileEngine.BehaviorContext.BASE_DIRECTION:
				_current_context.get_or_add(_behavior_context, _projectile_instance.base_direction)

			ProjectileEngine.BehaviorContext.ROTATION:
				_current_context.get_or_add(_behavior_context, _projectile_instance.rotation)

			ProjectileEngine.BehaviorContext.BASE_SCALE:
				_current_context.get_or_add(_behavior_context, _projectile_instance.scale)

			ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR:
				var _rng_array := []
				_rng_array.append(RandomNumberGenerator.new())
				_rng_array.append(false)
				_current_context.get_or_add(_behavior_context, _rng_array)

			_:
				pass
	return 

#endregion
