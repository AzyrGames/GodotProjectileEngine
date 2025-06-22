extends ProjectileBehaviorScale
class_name ProjectileScaleRandom

## Behavior that applies random scale variations over time
##
## This behavior generates random scale values at specified intervals and applies
## them using the selected modification method.

@export var noise_strength: float = 0.1
@export var noise_frequency: float = 0.2
@export var noise_seed: int = 0
@export var smoothing_factor: float = 0.1  ## Controls smoothness of transitions (0 = instant, 1 = very slow)

@export var scale_modify_method: ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION

var _noise_timer: float = 0.0

## Requests required context values
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
		ProjectileEngine.BehaviorContext.BASE_SCALE
	]

func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR,
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE,
	]

## Processes scale behavior with random variations
func process_behavior(_value: Vector2, _context: Dictionary) -> Vector2:
	# Get context values
	var _rng_array := _context.get(ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR)
	var _life_time_second: float = _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)
	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
	var _base_scale: Vector2 = _context.get(ProjectileEngine.BehaviorContext.BASE_SCALE, Vector2.ONE)

	if _variable_array.size() == 0:
		_variable_array.append(0)

	# Initialize RNG if not already done
	if !_rng_array[1]:
		if noise_seed == 0:
			_rng_array[0].randomize()
		else:
			_rng_array[0].seed = noise_seed
		_rng_array[1] = true

	# Get or initialize noise scale from context array
	if _context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE].size() < 2:
		_context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE].append(Vector2.ONE)
	var _noise_scale: Vector2 = _context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE][1]

	# Update target scale if frequency interval passed
	if int(_life_time_second / noise_frequency) >= _variable_array[0]:
		_variable_array[0] += 1
		if _context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE].size() < 3:
			_context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE].append(Vector2.ONE)
		_context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE][2] = _generate_new_scale(_rng_array[0])

	# Smoothly interpolate towards target scale
	_noise_scale = _noise_scale.lerp(_context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE][2], smoothing_factor)
	_context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE][1] = _noise_scale

	# Apply scale modification
	match scale_modify_method:
		ScaleModifyMethod.ADDITION:
			return _base_scale + _noise_scale
		ScaleModifyMethod.MULTIPLICATION:
			return _base_scale * _noise_scale
		ScaleModifyMethod.OVERRIDE:
			return _noise_scale
		_:
			return _value

## Generates a new random scale vector
func _generate_new_scale(_rng: RandomNumberGenerator) -> Vector2:
	return Vector2(
		_rng.randf_range(1.0 - noise_strength, 1.0 + noise_strength),
		_rng.randf_range(1.0 - noise_strength, 1.0 + noise_strength)
	)
