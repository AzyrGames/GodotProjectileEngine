extends ProjectileBehaviorScale
class_name ProjectileScaleCurve

## Behavior that modifies projectile scale based on a Curve resource.
##
## This behavior samples a Curve over time and applies the sampled value to modify
## the projectile's scale according to the selected modification method (additive,
## multiplicative, or override).

enum LoopMethod {
	## Play curve once and keep final value
	ONCE_AND_DONE,
	## Loop curve from start to end repeatedly
	LOOP_FROM_START, 
	## Play forward then backward (ping-pong)
	LOOP_FROM_END,
}


## How the curve value modifies the scale (add/multiply/override)
@export var scale_modify_method : ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION
@export var scale_process_mode : ProcessMode
## How the curve loops over time
@export var scale_curve_loop_method : LoopMethod = LoopMethod.ONCE_AND_DONE
## What value to use for sampling the curve (time/distance/etc)
@export var scale_curve_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## Curve defining scale modification over [param scale_modify_method]
@export var scale_curve : Curve

var _scale_curve_sample : float
var _scale_curve_sample_value : float
var _new_scale_value : float


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA,
	]


## Processes scale behavior using curve sampling
func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {}
		
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float

	match scale_curve_loop_method:
		LoopMethod.ONCE_AND_DONE:
			_scale_curve_sample = _context_life_time_second
		LoopMethod.LOOP_FROM_START:
			_scale_curve_sample = fmod(_context_life_time_second, scale_curve.max_domain)
		LoopMethod.LOOP_FROM_END:
			if sign(pow(-1, int(_context_life_time_second / scale_curve.max_domain))) > 0:
				_scale_curve_sample = fmod(_context_life_time_second, scale_curve.max_domain)
			else:
				_scale_curve_sample = scale_curve.max_domain - fmod(_context_life_time_second, scale_curve.max_domain)

	_scale_curve_sample_value = scale_curve.sample_baked(_scale_curve_sample)
	
	behavior_values.clear()
	match scale_modify_method:
		ScaleModifyMethod.ADDITION:
			behavior_values[
				ProjectileEngine.ScaleModify.SCALE_ADDITION] = Vector2.ONE * _scale_curve_sample_value
		ScaleModifyMethod.ADDITION_OVER_TIME:
			match scale_process_mode:
				ProcessMode.PHYSICS:
					if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
						return behavior_values
					_new_scale_value = _scale_curve_sample_value * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
				ProcessMode.TICKS:
					_new_scale_value = _scale_curve_sample_value
			behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = _value + Vector2.ONE * _new_scale_value
		ScaleModifyMethod.MULTIPLICATION:
			behavior_values[ProjectileEngine.ScaleModify.SCALE_MULTIPLY] = _value * _scale_curve_sample_value
		ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
			behavior_values[ProjectileEngine.ScaleModify.BASE_SCALE_MULTIPLY] =  Vector2.ONE * _scale_curve_sample_value
		ScaleModifyMethod.OVERRIDE:
			behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] =  Vector2.ONE * _scale_curve_sample_value
		null:
			behavior_values
		_:
			behavior_values

	return behavior_values
