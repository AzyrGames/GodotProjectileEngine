extends ProjectileBehaviorRotation
class_name ProjectileRotationCurve
## Behavior that modifies projectile rotation based on a Curve resource.
##
## This behavior samples a Curve over time and applies the sampled value to modify
## the projectile's rotation according to the selected modification method (additive,
## multiplicative, or override).

enum LoopMethod {
	## Play curve once and keep final value
	ONCE_AND_DONE,
	## Loop curve from start to end repeatedly
	LOOP_FROM_START, 
	## Play forward then backward (ping-pong)
	LOOP_FROM_END,
}


## How the curve value modifies the rotation (add/multiply/override)
@export var rotation_modify_method : RotationModifyMethod = RotationModifyMethod.ADDTITION
## How the curve loops over time
@export var rotation_curve_loop_method : LoopMethod = LoopMethod.ONCE_AND_DONE
## What value to use for sampling the curve (time/distance/etc)
@export var rotation_curve_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## Curve defining rotation modification over [param rotation_modify_method]
@export var rotation_curve : Curve

var _is_cached : bool = false

var rotation_curve_cache : Array[float]
var rotation_curve_max_tick : int

var _rotation_curve_sample : float
var _rotation_curve_sample_value : float
var _result_value : float


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
	]


## Processes rotation behavior using curve sampling
func process_behavior(_value: float, _context: Dictionary) -> float:
	# Cache curve values if not already done
	if !_is_cached:
		caching_rotation_curve_value()
	
	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return _value
		
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float

	match rotation_curve_loop_method:
		LoopMethod.ONCE_AND_DONE:
			_rotation_curve_sample = _context_life_time_second
			pass
		LoopMethod.LOOP_FROM_START:
			_rotation_curve_sample = fmod(_context_life_time_second, rotation_curve.max_domain)
			pass
		LoopMethod.LOOP_FROM_END:
			if sign(pow(-1, int(_context_life_time_second / rotation_curve.max_domain))) > 0:
				_rotation_curve_sample = fmod(_context_life_time_second, rotation_curve.max_domain)
			else:
				_rotation_curve_sample = rotation_curve.max_domain - fmod(_context_life_time_second, rotation_curve.max_domain)
			# print(sign(pow(-1, int(_context_life_time_second / rotation_curve.max_domain))))

			pass
	# print("_rotation_curve_sample: ", _rotation_curve_sample)
	_rotation_curve_sample_value = rotation_curve.sample_baked(_rotation_curve_sample)
	# print(_rotation_curve_sample_value)
	
	match rotation_modify_method:
		RotationModifyMethod.ADDTITION:
			# if !_context.has(ProjectileEngine.BehaviorContext.BASE_SPEED): _result_value = _value
			# _result_value = _context.get(ProjectileEngine.BehaviorContext.BASE_SPEED) + _rotation_curve_sample_value
			_result_value = _value + _rotation_curve_sample_value
			pass
		# RotationModifyMethod.MULTIPLICATION:
		# 	if !_context.has(ProjectileEngine.BehaviorContext.BASE_SPEED): _result_value = _value
		# 	_result_value = _context.get(ProjectileEngine.BehaviorContext.BASE_SPEED) * _rotation_curve_sample_value
		# 	pass
		RotationModifyMethod.OVERRIDE:
			_result_value = _rotation_curve_sample_value
			pass
	return _result_value


## Caches sampled curve values for performance optimization
## Samples curve at physics tick intervals and stores in array
func caching_rotation_curve_value() -> void:
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	rotation_curve_cache.clear()
	rotation_curve_max_tick = int(rotation_curve.max_domain / _tick_time)
	
	# Sample curve at each physics tick interval
	for i in range(rotation_curve_max_tick):
		rotation_curve_cache.append(rotation_curve.sample(_tick_time * i))
		
	_is_cached = true
