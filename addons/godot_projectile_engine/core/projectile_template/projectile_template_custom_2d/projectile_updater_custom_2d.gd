extends ProjectileUpdater2D
class_name ProjectileUpdaterCustom2D

# var projectile_damage: float = 1.0

# var projectile_rotation_speed : float

# var behavior_static_context : Dictionary
# var behavior_dynamic_context : Dictionary
# var behavior_persist_context : Dictionary

# var behavior_context : Dictionary
# var projectile_behaviors : Array[ProjectileBehavior] = []


var velocity : Vector2
var life_time_second: float
var life_distance : float

var base_speed : float
var speed_final : float
var _speed_addition : float
var _speed_multiply : float
var behavior_values : Dictionary
var _speed_behavior_additions : Dictionary
var _speed_behavior_multiplies : Dictionary
var _base_speed_behavior_multiplies : Dictionary

var _speed_multiply_value : float

var base_direction : Vector2
var raw_direction : Vector2
var direction_final : Vector2
var _direction_behavior_values : Dictionary
var _direction_behavior_additions : Dictionary
var _direction_behavior_rotations : Dictionary
var _direction_rotation_value : float
var _direction_addition_value : Vector2
var _direction_addition : Vector2

var projectile_rotation : float
var base_rotation : float
var rotation_final : float
# var behavior_values : Dictionary
var _rotation_behavior_additions : Dictionary
var _rotation_behavior_multiplies : Dictionary
var _rotation_multiply_value : float
var _rotation_multiply : float
var _rotation_addition : float

var projectile_scale : Vector2
var base_scale : Vector2
var scale_final : Vector2
# var behavior_values : Dictionary
var _scale_behavior_additions : Dictionary
var _scale_behavior_multiplies : Dictionary
var _scale_multiply_value : Vector2
var _scale_multiply : Vector2
var _scale_addition : Vector2

var _behavior_context_requests_normal : Array[ProjectileEngine.BehaviorContext]
var _behavior_contest_requests_persist : Array[ProjectileEngine.BehaviorContext]

var projectile_behaviors : Array[ProjectileBehavior] = []

func init_updater_variable() -> void:
	projectile_template_2d = projectile_template_2d as ProjectileTemplateCustom2D
	_new_projectile_instance = Callable(ProjectileInstanceCustom2D, "new")
	
	projectile_behaviors = []
	projectile_behaviors.append_array(projectile_template_2d.speed_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.direction_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.rotation_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.scale_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.destroy_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.bouncing_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.piercing_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.trigger_projectile_behaviors)
	
	for _projectile_behavior in projectile_behaviors:
		if !_projectile_behavior: continue
		if !_projectile_behavior.active: continue
		_behavior_context_requests_normal.append_array(_projectile_behavior._request_behavior_context())
		_behavior_contest_requests_persist.append_array(_projectile_behavior._request_persist_behavior_context())

#region Spawn Projectile

func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	projectile_template_2d = projectile_template_2d as ProjectileTemplateCustom2D
	for _pattern_composer_data : PatternComposerData in pattern_composer_pack:
		_projectile_instance = projectile_instance_array[projectile_pooling_index]
		_projectile_instance = _projectile_instance as ProjectileInstanceCustom2D

		_projectile_instance.global_position = _pattern_composer_data.position
		_projectile_instance.speed = projectile_template_2d.speed
		_projectile_instance.direction = _pattern_composer_data.direction
		_projectile_instance.direction_rotation = _pattern_composer_data.direction_rotation
		_projectile_instance.texture_rotation = projectile_template_2d.texture_rotation
		_projectile_instance.scale = projectile_template_2d.scale
	

		# # Check and update random variables
		var _scale_float: float
		var _scale_max_float: float
		if projectile_template_2d.speed_random != Vector3.ZERO:
			_projectile_instance.speed = ProjectileEngine.get_random_float_value(
				projectile_template_2d.speed_random
			)
	
		# if projectile_template_2d.direction_rotation_random != Vector3.ZERO:
		# 	_projectile_instance.direction_rotation = ProjectileEngine.get_random_float_value(
		# 		projectile_template_2d.direction_rotation_random
		# 	)
	
		if projectile_template_2d.texture_rotation_random != Vector3.ZERO:
			_projectile_instance.texture_rotation = ProjectileEngine.get_random_float_value(
				projectile_template_2d.texture_rotation_random
			)
	
		if projectile_template_2d.scale_random != Vector3.ZERO:
			_scale_float = ProjectileEngine.get_random_float_value(
				projectile_template_2d.scale_random
			)
			_projectile_instance.scale = Vector2(_scale_float, _scale_float)
		
		_projectile_instance.transform = Transform2D(
			_projectile_instance.texture_rotation,
			_projectile_instance.scale,
			_projectile_instance.skew,
			_projectile_instance.global_position
		)

		_projectile_instance.base_speed = _projectile_instance.speed
		_projectile_instance.base_direction = _projectile_instance.direction
		_projectile_instance.base_direction_rotation = _projectile_instance.direction_rotation
		_projectile_instance.base_texture_rotation = _projectile_instance.texture_rotation
		_projectile_instance.base_scale = _projectile_instance.scale

		if projectile_template_2d.collision_shape:
			PS.area_set_shape_transform(
				projectile_area_rid, 
				projectile_pooling_index, 
				_projectile_instance.transform
				)
			PS.area_set_shape_disabled(
				projectile_area_rid, 
				projectile_pooling_index, 
				false
				)
		
		_projectile_instance.life_time_second = 0.0
		_projectile_instance.life_distance = 0.0
		_projectile_instance.trigger_count = 0

		projectile_instance_array[projectile_pooling_index] = _projectile_instance

		if projectile_pooling_index not in projectile_active_index:
			projectile_active_index.append(projectile_pooling_index)

		projectile_pooling_index += 1

		if projectile_pooling_index >= projectile_max_pooling:
			projectile_pooling_index = 0

	update_projectile_instances(get_physics_process_delta_time())
#endregion


#region Update Projectile

func update_projectile_instances(delta: float) -> void:
	# Check for projectile destroy condition
	for index : int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]

		_projectile_instance.behavior_context.clear()
		_projectile_instance.behavior_update_context.clear()

		process_behavior_context_request(
			_projectile_instance.behavior_update_context,
			_projectile_instance,
			_behavior_context_requests_normal
			)

		for behavior_persist_context_key in _projectile_instance.behavior_persist_context.keys():
			if !_projectile_instance.behavior_persist_context.has(behavior_persist_context_key):
				_projectile_instance.behavior_persist_context.erase(behavior_persist_context_key)

		process_behavior_context_request(
			_projectile_instance.behavior_persist_context,
			_projectile_instance,
			_behavior_contest_requests_persist
			)

		_projectile_instance.behavior_context.merge(_projectile_instance.behavior_update_context, true)
		_projectile_instance.behavior_context.merge(_projectile_instance.behavior_persist_context, true)

		_projectile_instance.life_time_second += delta
		_projectile_instance.life_distance += _projectile_instance.velocity.length()

		# Refresh Projectile Behavior Array Process
		for _behavior_key in _projectile_instance.behavior_context.keys():
			if _behavior_key != ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
				continue
			for _behavior_variable in _projectile_instance.behavior_context.get(_behavior_key):
				if _behavior_variable is not BehaviorVariable: continue
				_behavior_variable.is_processed = false

		# Projectile Trigger Behaviors
		if projectile_template_2d.trigger_projectile_behaviors.size() > 0:
			for _trigger_behavior in projectile_template_2d.trigger_projectile_behaviors:
				if !_trigger_behavior:
					continue
				if !_trigger_behavior.active:
					continue
				var _trigger_behavior_values : Dictionary = _trigger_behavior.process_behavior(
					null, _projectile_instance.behavior_context
					)
				if _trigger_behavior_values.has("is_trigger"):
					if _trigger_behavior_values.is_trigger:
						ProjectileEngine.projectile_instance_triggered.emit(
							_trigger_behavior.trigger_name, _projectile_instance
							)
				if _trigger_behavior_values.has("is_destroy"):
					if _trigger_behavior_values.is_destroy:
						projectile_remove_index.append(index)
						continue

		# Projectile Piercing Behaviors
		for _projectile_behavior in projectile_template_2d.piercing_projectile_behaviors:
			if !_projectile_behavior:
				continue

			if !_projectile_behavior.active:
				continue

			var _piercing_behavior_values : Dictionary = _projectile_behavior.process_behavior(
				null, _projectile_instance.behavior_context
				)

			if _piercing_behavior_values.size() <= 0:
				continue
			if _piercing_behavior_values.has("is_piercing") and _piercing_behavior_values.has("pierced_node"):
				ProjectileEngine.projectile_instance_pierced.emit(
					_projectile_instance,
					_piercing_behavior_values.get("pierced_node")
					)

		# Projectile Bouncing Behaviors
		for _projectile_behavior in projectile_template_2d.bouncing_projectile_behaviors:
			if !_projectile_behavior:
				continue

			if !_projectile_behavior.active:
				continue

			var projectile_bouncing_helper = ProjectileEngine.projectile_environment.projectile_bouncing_helper

			if projectile_bouncing_helper == null:
				ProjectileEngine.projectile_environment.request_bouncing_helper(
					projectile_collision_shape
					)
				ProjectileEngine.projectile_environment.projectile_bouncing_helper.collision_layer = self.projectile_collision_layer
				ProjectileEngine.projectile_environment.projectile_bouncing_helper.collision_mask = self.projectile_collision_mask

			var _bouncing_behavior_values : Dictionary = _projectile_behavior.process_behavior(
				null, _projectile_instance.behavior_context
				)
			if _bouncing_behavior_values.size() <= 0:
				continue
			if _bouncing_behavior_values.has("is_bouncing"): #and _bouncing_behavior_values.has(ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE):
				_projectile_instance.direction = _bouncing_behavior_values.get(ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE)
				pass

		# Projectile Destroy Behaviors
		for _projectile_behavior in projectile_template_2d.destroy_projectile_behaviors:
			if !_projectile_behavior:
				continue
			if !_projectile_behavior.active:
				continue
			if _projectile_behavior.process_behavior(null, _projectile_instance.behavior_context):
				projectile_remove_index.append(index)

	# Destroy projectile
	if projectile_remove_index.size() > 0:
		for index : int in projectile_remove_index:
			projectile_active_index.erase(index)
			if projectile_template_2d.collision_shape:
				PS.area_set_shape_disabled(projectile_area_rid, index, true)
		projectile_remove_index.clear()

	# Update active projectile instances array
	_active_projectile_instances.clear()
	for index : int in projectile_active_index:
		_active_projectile_instances.append(projectile_instance_array[index])
	if _active_projectile_instances.size() <= 0: return
	
	## Update Active Projectile Instances
	for _active_projectile_instance : ProjectileInstanceCustom2D in _active_projectile_instances:
		## Process Projectile Transform Behaviors
		## Projectile Behavior Speed
		if projectile_template_2d.speed_projectile_behaviors.size() > 0:
			_speed_behavior_additions.clear()
			_speed_behavior_multiplies.clear()
			_base_speed_behavior_multiplies.clear()
			for _projectile_behavior in projectile_template_2d.speed_projectile_behaviors:
				if !_projectile_behavior:
					continue
				if not _projectile_behavior.active:
					continue
				behavior_values = _projectile_behavior.process_behavior(
					_active_projectile_instance.speed,
					_active_projectile_instance.behavior_context
					)
				for _behavior_key in behavior_values.keys():
					match _behavior_key:
						ProjectileEngine.SpeedModify.SPEED_OVERWRITE:
							_active_projectile_instance.speed = behavior_values.get(ProjectileEngine.SpeedModify.SPEED_OVERWRITE)
						ProjectileEngine.SpeedModify.SPEED_ADDITION:
							_speed_behavior_additions.get_or_add(
								_projectile_behavior, behavior_values.get(ProjectileEngine.SpeedModify.SPEED_ADDITION)
								)
						ProjectileEngine.SpeedModify.SPEED_MULTIPLY:
							_speed_behavior_multiplies.get_or_add(
								_projectile_behavior, behavior_values.get(ProjectileEngine.SpeedModify.SPEED_MULTIPLY)
								)
						ProjectileEngine.SpeedModify.BASE_SPEED_MULTIPLY:
							_base_speed_behavior_multiplies.get_or_add(
								_projectile_behavior, behavior_values.get(ProjectileEngine.SpeedModify.BASE_SPEED_MULTIPLY)
								)
						ProjectileEngine.SpeedModify.SPEED_CLAMP:
							_projectile_instance.speed_clamp = behavior_values.get(ProjectileEngine.SpeedModify.SPEED_CLAMP)
	
		## Projectile Behavior Direction
		if projectile_template_2d.direction_projectile_behaviors.size() > 0:
			_direction_behavior_rotations.clear()
			_direction_behavior_additions.clear()
			for _projectile_behavior in projectile_template_2d.direction_projectile_behaviors:
				if !_projectile_behavior:
					continue
				if not _projectile_behavior.active:
					continue
				_direction_behavior_values = _projectile_behavior.process_behavior(
					_active_projectile_instance.direction,
					_active_projectile_instance.behavior_context
					)
				for _behavior_key in _direction_behavior_values.keys():
					match _behavior_key:
						ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE:
							_active_projectile_instance.direction = _direction_behavior_values.get(
								ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE
								)
						ProjectileEngine.DirectionModify.DIRECTION_ROTATION:
							_direction_behavior_rotations.get_or_add(
								_projectile_behavior,
								_direction_behavior_values.get(ProjectileEngine.DirectionModify.DIRECTION_ROTATION)
								)
						ProjectileEngine.DirectionModify.DIRECTION_ADDITION:
							_direction_behavior_additions.get_or_add(
								_projectile_behavior,
								_direction_behavior_values.get(ProjectileEngine.DirectionModify.DIRECTION_ADDITION)
								)

		## Projectile Behavior Rotation
		if projectile_template_2d.rotation_projectile_behaviors.size() > 0:
			_rotation_behavior_additions.clear()
			_rotation_behavior_multiplies.clear()
			for _projectile_behavior in projectile_template_2d.rotation_projectile_behaviors:
				if !_projectile_behavior:
					continue
				if not _projectile_behavior.active:
					continue
				behavior_values = _projectile_behavior.process_behavior(
					_active_projectile_instance.texture_rotation,
					_active_projectile_instance.behavior_context
					)
				for _behavior_key in behavior_values.keys():
					match _behavior_key:
						ProjectileEngine.RotationModify.ROTATION_OVERWRITE:
							_active_projectile_instance.texture_rotation = behavior_values.get(ProjectileEngine.RotationModify.ROTATION_OVERWRITE)
						ProjectileEngine.RotationModify.ROTATION_ADDITION:
							_rotation_behavior_additions.get_or_add(
								_projectile_behavior,
								behavior_values.get(ProjectileEngine.RotationModify.ROTATION_ADDITION)
								)
						"rotation_multiply":
							_rotation_behavior_multiplies.get_or_add(
								_projectile_behavior,
								behavior_values.get("rotation_multiply")
								)
		
		## Projectile Behavior Scale
		if projectile_template_2d.scale_projectile_behaviors.size() > 0:
			_scale_behavior_additions.clear()
			_scale_behavior_multiplies.clear()
			for _projectile_behavior in projectile_template_2d.scale_projectile_behaviors:
				if !_projectile_behavior:
					continue
				if not _projectile_behavior.active:
					continue
				behavior_values = _projectile_behavior.process_behavior(
					_active_projectile_instance.projectile_scale,
					_active_projectile_instance.behavior_context
					)
				if behavior_values.size() <= 0:
					continue
				for _behavior_key in behavior_values.keys():
					match _behavior_key:
						ProjectileEngine.ScaleModify.SCALE_OVERWRITE:
							_active_projectile_instance.projectile_scale = behavior_values.get(ProjectileEngine.ScaleModify.SCALE_OVERWRITE)
						ProjectileEngine.ScaleModify.SCALE_ADDITION:
							_scale_behavior_additions.get_or_add(
								_projectile_behavior,
								behavior_values.get(ProjectileEngine.ScaleModify.SCALE_ADDITION)
								)
						ProjectileEngine.ScaleModify.SCALE_MULTIPLY:
							_scale_behavior_multiplies.get_or_add(
								_projectile_behavior,
								behavior_values.get(ProjectileEngine.ScaleModify.SCALE_MULTIPLY)
								)

		## Apply Projectile behaviors

		## Apply Projectile behaviors Rotation
		rotation_final = _active_projectile_instance.texture_rotation
		if _rotation_behavior_multiplies.size() > 0:
			_rotation_multiply_value = 0.0
			for _rotation_behavior_multiply in _rotation_behavior_multiplies.values():
				_rotation_multiply_value += _rotation_behavior_multiply
			_rotation_multiply = base_rotation * _rotation_multiply_value
			rotation_final += _rotation_multiply
		if _rotation_behavior_additions.size() > 0:
			_rotation_addition = 0.0
			for _rotation_behavior_addition in _rotation_behavior_additions.values():
				_rotation_addition += _rotation_behavior_addition
			rotation_final += _rotation_addition
		_active_projectile_instance.texture_rotation = rotation_final

		## Apply Projectile behaviors Scale
		scale_final = _active_projectile_instance.scale
		if _scale_behavior_multiplies.size() > 0:
			_scale_multiply_value = Vector2.ZERO
			for _scale_behavior_multiply in _scale_behavior_multiplies.values():
				_scale_multiply_value += _scale_behavior_multiply
			_scale_multiply = base_scale * _scale_multiply_value
			scale_final += _scale_multiply
		if _scale_behavior_additions.size() > 0:
			_scale_addition = Vector2.ZERO
			for _scale_behavior_addition in _scale_behavior_additions.values():
				_scale_addition += _scale_behavior_addition
			scale_final += _scale_addition
		_active_projectile_instance.scale = scale_final

		## Apply Projectile behaviors Direction
		var _direction_rotation_final := _active_projectile_instance.direction_rotation
		if _direction_behavior_rotations.size() > 0:
			for _direction_behavior_rotation in _direction_behavior_rotations.values():
				_direction_rotation_final += _direction_behavior_rotation
		_active_projectile_instance.direction_rotation = _direction_rotation_final
	
		## Apply Projectile behaviors Speed
		_active_projectile_instance.speed_final = _active_projectile_instance.speed
		if _speed_behavior_additions.size() > 0:
			_speed_addition = 0
			for _speed_behavior_addition in _speed_behavior_additions.values():
				_speed_addition += _speed_behavior_addition
			_active_projectile_instance.speed_final += _speed_addition
		if _speed_behavior_multiplies.size() > 0:
			_speed_multiply_value = 0
			for _speed_behavior_multiply in _speed_behavior_multiplies.values():
				_speed_multiply_value += _speed_behavior_multiply - 1.0
			_speed_multiply = _active_projectile_instance.speed * _speed_multiply_value
			_active_projectile_instance.speed_final += _speed_multiply
		if _base_speed_behavior_multiplies.size() > 0:
			_speed_multiply_value = 0
			for _base_speed_behavior_multiply in _base_speed_behavior_multiplies.values():
				_speed_multiply_value += _base_speed_behavior_multiply
			_speed_multiply = _active_projectile_instance.base_speed * _speed_multiply_value
			_active_projectile_instance.speed_final += _speed_multiply
		
		# _active_projectile_instance.speed_final _projectile_instance.speed_clamp
		if _projectile_instance.speed_clamp != Vector2.ZERO:
			_active_projectile_instance.speed_final = clamp(
				_active_projectile_instance.speed_final, 
				_projectile_instance.speed_clamp.x, 
				_projectile_instance.speed_clamp.y
				)

		## Update Velocity
		if _active_projectile_instance.direction_rotation != 0:
			_active_projectile_instance.direction = _active_projectile_instance.base_direction.rotated(
				_active_projectile_instance.direction_rotation
			)

		_active_projectile_instance.velocity = _active_projectile_instance.speed_final * _active_projectile_instance.direction * delta
		_active_projectile_instance.global_position += _active_projectile_instance.velocity

		_active_projectile_instance.transform = Transform2D(
			_active_projectile_instance.texture_rotation,
			_active_projectile_instance.scale,
			_active_projectile_instance.skew,
			_active_projectile_instance.global_position
			)

		if projectile_template_2d.collision_shape:
			PS.area_set_shape_transform(
				projectile_area_rid,
				_active_projectile_instance.area_index,
				_active_projectile_instance.transform
				)

func update_projectile_behavior_context() -> void:
	pass


func process_behavior_context_request(
	_behavior_context: Dictionary,
	projectile_instance: ProjectileInstanceCustom2D,
	_behavior_context_requests: Array[ProjectileEngine.BehaviorContext]
	) -> void:
	for _behavior_context_request in _behavior_context_requests:
		match _behavior_context_request:
			ProjectileEngine.BehaviorContext.PHYSICS_DELTA:
				_behavior_context.get_or_add(_behavior_context_request, get_physics_process_delta_time())

			ProjectileEngine.BehaviorContext.GLOBAL_POSITION:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.global_position)

			ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER:
				_behavior_context.get_or_add(_behavior_context_request, projectile_instance)

			ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.life_time_second)

			ProjectileEngine.BehaviorContext.LIFE_DISTANCE:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.life_distance)

			ProjectileEngine.BehaviorContext.BASE_SPEED:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.base_speed)

			ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
				_behavior_context.get_or_add(_behavior_context_request, [])

			ProjectileEngine.BehaviorContext.DIRECTION:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.direction)

			ProjectileEngine.BehaviorContext.DIRECTION_ROTATION:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.direction_rotation)

			ProjectileEngine.BehaviorContext.BASE_DIRECTION:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.base_direction)

			ProjectileEngine.BehaviorContext.ROTATION:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.texture_rotation)

			ProjectileEngine.BehaviorContext.BASE_SCALE:
				_behavior_context.get_or_add(_behavior_context_request, _projectile_instance.scale)

			ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR:
				var _rng_array := []
				_rng_array.append(RandomNumberGenerator.new())
				_rng_array.append(false)
				_behavior_context.get_or_add(_behavior_context_request, _rng_array)
			_:
				pass
	return

#endregion
