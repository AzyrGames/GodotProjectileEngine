extends ProjectileBehaviorSpeed
class_name ProjectileSpeedCurve

## Behavior that modifies projectile speed based on a Curve resource.
##
## This behavior samples a Curve over time and applies the sampled value to modify
## the projectile's speed according to the selected modification method (additive,
## multiplicative, or override).

enum LoopMethod {
	## Play curve once and keep final value
	ONCE_AND_DONE,
	## Loop curve from start to end repeatedly
	LOOP_FROM_START, 
	## Play forward then backward (ping-pong)
	LOOP_FROM_END,
}


## How the curve value modifies the speed (add/multiply/override)
@export var speed_modify_method : SpeedModifyMethod = SpeedModifyMethod.MULTIPLICATION
## How the curve loops over time
@export var speed_curve_loop_method : LoopMethod = LoopMethod.ONCE_AND_DONE
## What value to use for sampling the curve (time/distance/etc)
@export var speed_curve_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## Curve defining speed modification over [param speed_modify_method]
@export var speed_curve : Curve

var _is_cached : bool = false

var speed_curve_cache : Array[float]
var speed_curve_max_tick : int

var _speed_curve_sample : float
var _speed_curve_sample_value : float
var _result_value : float


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
	]


## Processes speed behavior using curve sampling
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	# Cache curve values if not already done
	if !_is_cached:
		caching_speed_curve_value()
	
	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {"speed_overwrite" : _value}
		
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float

	match speed_curve_loop_method:
		LoopMethod.ONCE_AND_DONE:
			_speed_curve_sample = _context_life_time_second
			pass
		LoopMethod.LOOP_FROM_START:
			_speed_curve_sample = fmod(_context_life_time_second, speed_curve.max_domain)
			pass
		LoopMethod.LOOP_FROM_END:
			if sign(pow(-1, int(_context_life_time_second / speed_curve.max_domain))) > 0:
				_speed_curve_sample = fmod(_context_life_time_second, speed_curve.max_domain)
			else:
				_speed_curve_sample = speed_curve.max_domain - fmod(_context_life_time_second, speed_curve.max_domain)

	_speed_curve_sample_value = speed_curve.sample_baked(_speed_curve_sample)
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			_speed_behavior_values["speed_overwrite"] = _value + _speed_curve_sample_value

		SpeedModifyMethod.ADDITION_OVER_BASE:
			_speed_behavior_values["speed_addition"] = _speed_curve_sample_value

		SpeedModifyMethod.MULTIPLICATION:
			_speed_behavior_values["speed_overwrite"] = _value * _speed_curve_sample_value

		SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
			_speed_behavior_values["speed_multiply"] =  _speed_curve_sample_value

		SpeedModifyMethod.OVERRIDE:
			_speed_behavior_values["speed_overwrite"] = _speed_curve_sample_value
		null:
			_speed_behavior_values["speed_overwrite"] = _value
		_:
			_speed_behavior_values["speed_overwrite"] = _value
			
	return _speed_behavior_values



## Caches sampled curve values for performance optimization
## Samples curve at physics tick intervals and stores in array
func caching_speed_curve_value() -> void:
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	speed_curve_cache.clear()
	speed_curve_max_tick = int(speed_curve.max_domain / _tick_time)
	
	# Sample curve at each physics tick interval
	for i in range(speed_curve_max_tick):
		speed_curve_cache.append(speed_curve.sample(_tick_time * i))
		
	_is_cached = true
