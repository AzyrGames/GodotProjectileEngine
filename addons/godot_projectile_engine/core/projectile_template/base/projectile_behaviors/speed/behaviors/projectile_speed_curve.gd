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
@export var speed_process_mode : ProcessMode
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
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA
	]


## Processes speed behavior using curve sampling
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	# Cache curve values if not already done
	if !_is_cached:
		caching_speed_curve_value()
	
	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {ProjectileEngine.SpeedModify.SPEED_OVERWRITE : _value}
		
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

	behavior_values.clear()
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_ADDITION] = _speed_curve_sample_value

		SpeedModifyMethod.ADDITION_OVER_TIME:
			match speed_process_mode:
				ProcessMode.PHYSICS:
					behavior_values[
						ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value + _speed_curve_sample_value \
						* _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
				ProcessMode.TICKS:
					behavior_values[
						ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value + _speed_curve_sample_value

		SpeedModifyMethod.MULTIPLICATION:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_MULTIPLY] = _speed_curve_sample_value

		SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
			behavior_values[ProjectileEngine.SpeedModify.BASE_SPEED_MULTIPLY] =  _speed_curve_sample_value

		SpeedModifyMethod.OVERRIDE:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _speed_curve_sample_value

		null:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value

		_:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value

	return behavior_values



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
