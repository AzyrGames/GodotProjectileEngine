extends ProjectileBehaviorDirection
class_name ProjectileDirectionRandomWalk

@export var noise_strength: float = 0.1
@export var noise_frequency: float = 0.2
@export var noise_seed: int = 0

# Todo: Option to all random seed or all same random seed

@export var direction_modify_method: DirectionModifyMethod

var _noise_direction: Vector2 = Vector2.ZERO
var _noise_timer: float = 0.0


func _ready() -> void:
	pass

func setup_rng(_rng: RandomNumberGenerator) -> void:
	if noise_seed == 0:
		_rng.randomize()
	else:
		_rng.seed = noise_seed
	pass


## Requests required context _values
func _request_behavior_context() -> Array:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
		]


func _request_persist_behavior_context() -> Array:
	return [
		ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR,
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE,
		]


## Processes direction behavior with random walk
func process_behavior(_value: Vector2, _component_context: Dictionary) -> Dictionary:
	# Get delta time from _context
	var _rng_array := _component_context.get(ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR)
	var _life_time_second: float = _component_context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)
	var _variable_array: Array = _component_context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
	var _behavior_variable_random_walk : BehaviorVariableRandomWalk

	if _variable_array.size() <= 0:
		_behavior_variable_random_walk = null

	for _variable in _variable_array:
		if _variable is BehaviorVariableRandomWalk:
			if !_variable.is_processed:
				_behavior_variable_random_walk = _variable
			break
		else:
			_behavior_variable_random_walk = null

	if _behavior_variable_random_walk == null:
		_behavior_variable_random_walk = BehaviorVariableRandomWalk.new()
		_variable_array.append(_behavior_variable_random_walk)

	_behavior_variable_random_walk.is_processed = true

	if !_rng_array[1]:
		if noise_seed == 0:
			_rng_array[0].randomize()
		else:
			_rng_array[0].seed = noise_seed
		_rng_array[1] = true

	_direction_behavior_values.clear()
	# # Update noise direction if frequency interval passed
	if int(_life_time_second / noise_frequency) >= _behavior_variable_random_walk.frequency_count:
		_behavior_variable_random_walk.frequency_count += 1
		_noise_direction = _generate_new_noise(_component_context.get(ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR)[0])
		match direction_modify_method:
			DirectionModifyMethod.ROTATION:
				_direction_behavior_values[ProjectileEngine.DirectionModify.DIRECTION_ROTATION] = _noise_direction.angle()
			DirectionModifyMethod.ADDITION:
				_direction_behavior_values[ProjectileEngine.DirectionModify.DIRECTION_ADDITION] = _noise_direction
			DirectionModifyMethod.OVERRIDE:
				_direction_behavior_values[ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE] = _noise_direction
			_:
				_direction_behavior_values[ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE] = _value
	

	return _direction_behavior_values

## Generates a new random direction vector
func _generate_new_noise(_rng: RandomNumberGenerator) -> Vector2:
	var angle := _rng.randf_range(0, TAU)  # TAU = 2*PI
	return Vector2(cos(angle), sin(angle)) * noise_strength
