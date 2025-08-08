# extends ProjectileBehaviorScale
# class_name ProjectileScaleRandom

# ## Behavior that applies random scale variations over time
# ##
# ## This behavior generates random scale values at specified intervals and applies
# ## them using the selected modification method.

# @export var noise_strength: float = 0.1
# @export var noise_frequency: float = 0.2
# @export var noise_seed: int = 0
# @export var smoothing_factor: float = 0.1  ## Controls smoothness of transitions (0 = instant, 1 = very slow)

# @export var scale_modify_method: ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION

# var _noise_timer: float = 0.0

# ## Requests required context values
# func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
# 		ProjectileEngine.BehaviorContext.BASE_SCALE
# 	]

# func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR,
# 		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE,
# 	]

# ## Processes scale behavior with random variations
# func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
# 	# Get context values
# 	var _rng_array := _context.get(ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR)
# 	var _life_time_second: float = _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)
# 	var _base_scale: Vector2 = _context.get(ProjectileEngine.BehaviorContext.BASE_SCALE, Vector2.ONE)
# 	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
# 	var _behavior_variable_scale_random : BehaviorVariableScaleRandom

# 	if _variable_array.size() <= 0:
# 		_behavior_variable_scale_random = null

# 	for _variable in _variable_array:
# 		if _variable is BehaviorVariableScaleRandom:
# 			if !_variable.is_processed:
# 				_behavior_variable_scale_random = _variable
# 			break
# 		else:
# 			_behavior_variable_scale_random = null

# 	if _behavior_variable_scale_random == null:
# 		_behavior_variable_scale_random = BehaviorVariableScaleRandom.new()
# 		_variable_array.append(_behavior_variable_scale_random)
	
# 	_behavior_variable_scale_random.is_processed = true


# 	# Initialize RNG if not already done
# 	if !_rng_array[1]:
# 		if noise_seed == 0:
# 			_rng_array[0].randomize()
# 		else:
# 			_rng_array[0].seed = noise_seed
# 		_rng_array[1] = true

# 	var _noise_scale: Vector2 = _behavior_variable_scale_random.noise_scale

# 	# Update target scale if frequency interval passed
# 	if int(_life_time_second / noise_frequency) >= _behavior_variable_scale_random.frequency_count:
# 		_behavior_variable_scale_random.frequency_count += 1
# 		_behavior_variable_scale_random.target_noise_scale = _generate_new_scale(_rng_array[0])
# 	# Smoothly interpolate towards target scale
# 	_noise_scale = _noise_scale.lerp(_behavior_variable_scale_random.target_noise_scale, smoothing_factor)
# 	_behavior_variable_scale_random.noise_scale = _noise_scale
# 	# Apply scale modification

# 	behavior_values.clear()
# 	match scale_modify_method:
# 		ScaleModifyMethod.ADDITION:
# 			behavior_values[
# 				ProjectileEngine.ScaleModify.SCALE_ADDITION] = Vector2.ONE * _scale_expression_result
# 		ScaleModifyMethod.ADDITION_OVER_TIME:
# 			match scale_process_mode:
# 				ProcessMode.PHYSICS:
# 					if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
# 						return behavior_values
# 					_new_scale_value = _scale_expression_result * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
# 				ProcessMode.TICKS:
# 					_new_scale_value = _scale_expression_result
# 			behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = _value + Vector2.ONE * _new_scale_value
# 		ScaleModifyMethod.MULTIPLICATION:
# 			behavior_values[ProjectileEngine.ScaleModify.SCALE_MULTIPLY] = _value * _scale_expression_result
# 		ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
# 			behavior_values[ProjectileEngine.ScaleModify.BASE_SCALE_MULTIPLY] =  Vector2.ONE * _scale_expression_result
# 		ScaleModifyMethod.OVERRIDE:
# 			behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] =  Vector2.ONE * _scale_expression_result
# 		null:
# 			behavior_values
# 		_:
# 			behavior_values

# 	return behavior_values


# ## Generates a new random scale vector
# func _generate_new_scale(_rng: RandomNumberGenerator) -> Vector2:
# 	return Vector2(
# 		_rng.randf_range(1.0 - noise_strength, 1.0 + noise_strength),
# 		_rng.randf_range(1.0 - noise_strength, 1.0 + noise_strength)
# 	)
