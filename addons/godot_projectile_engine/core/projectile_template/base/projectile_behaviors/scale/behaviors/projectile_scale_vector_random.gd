# extends ProjectileBehaviorScale
# class_name ProjectileScaleVectorRandom

# ## Behavior that applies independent random scale variations to x and y components
# ##
# ## This behavior generates random scale values for each axis at specified intervals
# ## and applies them using the selected modification method.

# @export_group("X Scale Random")
# ## Enable random scaling for x axis
# @export var enable_x_random: bool = true
# ## Strength of random variation for x scale
# @export var noise_strength_x: float = 0.1
# ## Frequency of random changes for x scale
# @export var noise_frequency_x: float = 0.2
# ## Random seed for x scale (0 = random)
# @export var noise_seed_x: int = 0
# ## Smoothing factor for x scale transitions (0 = instant, 1 = very slow)
# @export var smoothing_factor_x: float = 0.1
# ## How the x scale value modifies the scale (add/multiply/override)
# @export var scale_modify_method_x: ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION

# # Array index constants for better readability
# const NOISE_INDEX := 0
# const NEW_SCALE_INDEX := 1
# const NOISE_SCALE_INDEX := 2

# @export_group("Y Scale Random")
# ## Enable random scaling for y axis
# @export var enable_y_random: bool = true
# ## Strength of random variation for y scaleextends ProjectileBehaviorScale
# class_name ProjectileScaleVectorRandom

# ## Behavior that applies independent random scale variations to x and y components
# ##
# ## This behavior generates random scale values for each axis at specified intervals
# ## and applies them using the selected modification method.

# @export_group("X Scale Random")
# ## Enable random scaling for x axis
# @export var enable_x_random: bool = true
# ## Strength of random variation for x scale
# @export var noise_strength_x: float = 0.1
# ## Frequency of random changes for x scale
# @export var noise_frequency_x: float = 0.2
# ## Random seed for x scale (0 = random)
# @export var noise_seed_x: int = 0
# ## Smoothing factor for x scale transitions (0 = instant, 1 = very slow)
# @export var smoothing_factor_x: float = 0.1
# ## How the x scale value modifies the scale (add/multiply/override)
# @export var scale_modify_method_x: ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION

# # Array index constants for better readability
# const NOISE_INDEX := 0
# const NEW_SCALE_INDEX := 1
# const NOISE_SCALE_INDEX := 2

# @export_group("Y Scale Random")
# ## Enable random scaling for y axis
# @export var enable_y_random: bool = true
# ## Strength of random variation for y scale
# @export var noise_strength_y: float = 0.1
# ## Frequency of random changes for y scale
# @export var noise_frequency_y: float = 0.2
# ## Random seed for y scale (0 = random)
# @export var noise_seed_y: int = 0
# ## Smoothing factor for y scale transitions (0 = instant, 1 = very slow)
# @export var smoothing_factor_y: float = 0.1
# ## How the y scale value modifies the scale (add/multiply/override)
# @export var scale_modify_method_y: ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION

# var _noise_index_x: float = 0.0
# var _noise_index_y: float = 0.0

# ## Requests required context values
# func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.PHYSICS_DELTA,
# 		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
# 		ProjectileEngine.BehaviorContext.BASE_SCALE
# 	]

# func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR,
# 		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE,
# 	]

# ## Processes scale behavior with independent random variations for x and y
# func process_behavior(_value: Vector2, _context: Dictionary) -> Vector2:
# 	# Return _value if both random is disabled
# 	if !enable_x_random and !enable_y_random:
# 		return _value
# 	# Get context values
# 	var _physics_delta := _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
# 	var _rng_array := _context.get(ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR)
# 	var _life_time_second: float = _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)
# 	var _base_scale: Vector2 = _context.get(ProjectileEngine.BehaviorContext.BASE_SCALE, Vector2.ONE)

# 	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
# 	var _behavior_variable_scale_random : BehaviorVariableScaleRandom

# 	for _variable in _variable_array:
# 		if _variable is BehaviorVariableScaleRandom:
# 			if !_variable.is_processed:
# 				_behavior_variable_scale_random = _variable
# 	if _behavior_variable_scale_random == null:
# 		_behavior_variable_scale_random = BehaviorVariableScaleRandom.new()
# 		_variable_array.append(_behavior_variable_scale_random)
	
# 	_behavior_variable_scale_random.is_processed = true


# 	var _noise_index : Vector2 = _behavior_variable_scale_random.frequency_index
# 	var new_scale = _behavior_variable_scale_random.noise_scale
# 	var _noise_scale: Vector2 = _behavior_variable_scale_random.target_noise_scale

# 	# Initialize RNGs if not already done
# 	if enable_x_random && !_rng_array[1]:
# 		if noise_seed_x == 0:
# 			_rng_array[0].randomize()
# 		else:
# 			_rng_array[0].seed = noise_seed_x
# 		_rng_array[1] = true
		
# 	if enable_y_random:
# 		# Dynamic RNG
# 		_rng_array.append(RandomNumberGenerator.new())
# 		_rng_array.append(false)
# 		if !_rng_array[3]:
# 			if noise_seed_y == 0:
# 				_rng_array[2].randomize()
# 			else:
# 				_rng_array[2].seed = noise_seed_y
# 			_rng_array[3] = true

# 	# print(_noise_index)
# 	# Update target scales if frequency intervals passed
# 	if enable_x_random && int(_life_time_second / noise_frequency_x) >= _noise_index.x:
# 		_noise_index.x += 1
# 		new_scale.x = _generate_new_scale_x(_rng_array[0])
# 		_behavior_variable_scale_random.target_noise_scale = new_scale

# 	if enable_y_random && int(_life_time_second / noise_frequency_y) >= _noise_index.y:
# 		_noise_index.y += 1
# 		new_scale.y = _generate_new_scale_y(_rng_array[2])
# 		_behavior_variable_scale_random.target_noise_scale = new_scale

# 	_variable_array[NOISE_INDEX] = _noise_index

# 	# Smoothly interpolate towards target scales
# 	_noise_scale.x = lerp(_noise_scale.x, _behavior_variable_scale_random.target_noise_scale.x, smoothing_factor_x)
# 	_noise_scale.y = lerp(_noise_scale.y, _behavior_variable_scale_random.target_noise_scale.y, smoothing_factor_y)
# 	_behavior_variable_scale_random.noise_scale = _noise_scale

# 	# Apply scale modifications independently
# 	var result := _value
# 	match scale_modify_method_x:
# 		ScaleModifyMethod.ADDITION:
# 			result.x = _base_scale.x + _noise_scale.x
# 		ScaleModifyMethod.MULTIPLICATION:
# 			result.x = _base_scale.x * _noise_scale.x
# 		ScaleModifyMethod.OVERRIDE:
# 			result.x = _noise_scale.x

# 	match scale_modify_method_y:
# 		ScaleModifyMethod.ADDITION:
# 			result.y = _base_scale.y + _noise_scale.y
# 		ScaleModifyMethod.MULTIPLICATION:
# 			result.y = _base_scale.y * _noise_scale.y
# 		ScaleModifyMethod.OVERRIDE:
# 			result.y = _noise_scale.y

# 	return result

# ## Generates a new random scale for x component
# func _generate_new_scale_x(_rng: RandomNumberGenerator) -> float:
# 	return _rng.randf_range(1.0 - noise_strength_x, 1.0 + noise_strength_x)

# ## Generates a new random scale for y component
# func _generate_new_scale_y(_rng: RandomNumberGenerator) -> float:
# 	return _rng.randf_range(1.0 - noise_strength_y, 1.0 + noise_strength_y)

# @export var noise_strength_y: float = 0.1
# ## Frequency of random changes for y scale
# @export var noise_frequency_y: float = 0.2
# ## Random seed for y scale (0 = random)
# @export var noise_seed_y: int = 0
# ## Smoothing factor for y scale transitions (0 = instant, 1 = very slow)
# @export var smoothing_factor_y: float = 0.1
# ## How the y scale value modifies the scale (add/multiply/override)
# @export var scale_modify_method_y: ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION

# var _noise_index_x: float = 0.0
# var _noise_index_y: float = 0.0

# ## Requests required context values
# func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.PHYSICS_DELTA,
# 		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
# 		ProjectileEngine.BehaviorContext.BASE_SCALE
# 	]

# func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR,
# 		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE,
# 	]

# ## Processes scale behavior with independent random variations for x and y
# func process_behavior(_value: Vector2, _context: Dictionary) -> Vector2:
# 	# Return _value if both random is disabled
# 	if !enable_x_random and !enable_y_random:
# 		return _value
# 	# Get context values
# 	var _physics_delta := _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
# 	var _rng_array := _context.get(ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR)
# 	var _life_time_second: float = _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)
# 	var _base_scale: Vector2 = _context.get(ProjectileEngine.BehaviorContext.BASE_SCALE, Vector2.ONE)

# 	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
# 	var _behavior_variable_scale_random : BehaviorVariableScaleRandom

# 	for _variable in _variable_array:
# 		if _variable is BehaviorVariableScaleRandom:
# 			if !_variable.is_processed:
# 				_behavior_variable_scale_random = _variable
# 	if _behavior_variable_scale_random == null:
# 		_behavior_variable_scale_random = BehaviorVariableScaleRandom.new()
# 		_variable_array.append(_behavior_variable_scale_random)
	
# 	_behavior_variable_scale_random.is_processed = true


# 	var _noise_index : Vector2 = _behavior_variable_scale_random.frequency_index
# 	var new_scale = _behavior_variable_scale_random.noise_scale
# 	var _noise_scale: Vector2 = _behavior_variable_scale_random.target_noise_scale

# 	# Initialize RNGs if not already done
# 	if enable_x_random && !_rng_array[1]:
# 		if noise_seed_x == 0:
# 			_rng_array[0].randomize()
# 		else:
# 			_rng_array[0].seed = noise_seed_x
# 		_rng_array[1] = true
		
# 	if enable_y_random:
# 		# Dynamic RNG
# 		_rng_array.append(RandomNumberGenerator.new())
# 		_rng_array.append(false)
# 		if !_rng_array[3]:
# 			if noise_seed_y == 0:
# 				_rng_array[2].randomize()
# 			else:
# 				_rng_array[2].seed = noise_seed_y
# 			_rng_array[3] = true

# 	# print(_noise_index)
# 	# Update target scales if frequency intervals passed
# 	if enable_x_random && int(_life_time_second / noise_frequency_x) >= _noise_index.x:
# 		_noise_index.x += 1
# 		new_scale.x = _generate_new_scale_x(_rng_array[0])
# 		_behavior_variable_scale_random.target_noise_scale = new_scale

# 	if enable_y_random && int(_life_time_second / noise_frequency_y) >= _noise_index.y:
# 		_noise_index.y += 1
# 		new_scale.y = _generate_new_scale_y(_rng_array[2])
# 		_behavior_variable_scale_random.target_noise_scale = new_scale

# 	_variable_array[NOISE_INDEX] = _noise_index

# 	# Smoothly interpolate towards target scales
# 	_noise_scale.x = lerp(_noise_scale.x, _behavior_variable_scale_random.target_noise_scale.x, smoothing_factor_x)
# 	_noise_scale.y = lerp(_noise_scale.y, _behavior_variable_scale_random.target_noise_scale.y, smoothing_factor_y)
# 	_behavior_variable_scale_random.noise_scale = _noise_scale

# 	# Apply scale modifications independently
# 	var result := _value
# 	match scale_modify_method_x:
# 		ScaleModifyMethod.ADDITION:
# 			result.x = _base_scale.x + _noise_scale.x
# 		ScaleModifyMethod.MULTIPLICATION:
# 			result.x = _base_scale.x * _noise_scale.x
# 		ScaleModifyMethod.OVERRIDE:
# 			result.x = _noise_scale.x

# 	match scale_modify_method_y:
# 		ScaleModifyMethod.ADDITION:
# 			result.y = _base_scale.y + _noise_scale.y
# 		ScaleModifyMethod.MULTIPLICATION:
# 			result.y = _base_scale.y * _noise_scale.y
# 		ScaleModifyMethod.OVERRIDE:
# 			result.y = _noise_scale.y

# 	return result

# ## Generates a new random scale for x component
# func _generate_new_scale_x(_rng: RandomNumberGenerator) -> float:
# 	return _rng.randf_range(1.0 - noise_strength_x, 1.0 + noise_strength_x)

# ## Generates a new random scale for y component
# func _generate_new_scale_y(_rng: RandomNumberGenerator) -> float:
# 	return _rng.randf_range(1.0 - noise_strength_y, 1.0 + noise_strength_y)
