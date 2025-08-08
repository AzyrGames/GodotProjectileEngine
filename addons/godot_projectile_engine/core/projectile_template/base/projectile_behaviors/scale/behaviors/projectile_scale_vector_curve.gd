extends ProjectileBehaviorScale
class_name ProjectileScaleVectorCurve

## Behavior that modifies projectile scale using separate curves for x and y components.
##
## This behavior samples two Curve resources over time and applies the sampled values
## to modify the projectile's scale components according to the selected modification
## method (additive, multiplicative, or override).

enum LoopMethod {
	## Play curve once and keep final value
	ONCE_AND_DONE,
	## Loop curve from start to end repeatedly
	LOOP_FROM_START, 
	## Play forward then backward (ping-pong)
	LOOP_FROM_END,
}

@export_group("X Scale Curve")
## How the x curve value modifies the scale (add/multiply/override)
@export var scale_modify_method_x : ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION
@export var scale_process_mode_x : ProcessMode
## How the x curve loops over time
@export var scale_curve_loop_method_x : LoopMethod = LoopMethod.ONCE_AND_DONE
## What value to use for sampling the x curve (time/distance/etc)
@export var scale_curve_sample_method_x : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## Curve defining scale modification for x component
@export var scale_curve_x : Curve

@export_group("Y Scale Curve")
## How the y curve value modifies the scale (add/multiply/override)
@export var scale_modify_method_y : ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION
@export var scale_process_mode_y : ProcessMode
## How the y curve loops over time
@export var scale_curve_loop_method_y : LoopMethod = LoopMethod.ONCE_AND_DONE
## What value to use for sampling the y curve (time/distance/etc)
@export var scale_curve_sample_method_y : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## Curve defining scale modification for y component
@export var scale_curve_y : Curve

var _scale_curve_sample_x : float
var _scale_curve_sample_y : float
var _scale_curve_sample_value_x : float
var _scale_curve_sample_value_y : float

var _new_scale_value : Vector2


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
	]

## Processes scale behavior using curve sampling for both x and y components
func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {}
		
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float

	# Initialize result with original value
	var result := _value
	
	behavior_values.clear()
	# Handle x scale if curve exists
	if scale_curve_x:
		# Calculate sample position based on loop method
		match scale_curve_loop_method_x:
			LoopMethod.ONCE_AND_DONE:
				_scale_curve_sample_x = _context_life_time_second
			LoopMethod.LOOP_FROM_START:
				_scale_curve_sample_x = fmod(_context_life_time_second, scale_curve_x.max_domain)
			LoopMethod.LOOP_FROM_END:
				if sign(pow(-1, int(_context_life_time_second / scale_curve_x.max_domain))) > 0:
					_scale_curve_sample_x = fmod(_context_life_time_second, scale_curve_x.max_domain)
				else:
					_scale_curve_sample_x = scale_curve_x.max_domain - fmod(_context_life_time_second, scale_curve_x.max_domain)
		
		# Sample curve and apply modification
		_scale_curve_sample_value_x = scale_curve_x.sample_baked(_scale_curve_sample_x)

		match scale_modify_method_x:
			ScaleModifyMethod.ADDITION:
				behavior_values[
					ProjectileEngine.ScaleModify.SCALE_ADDITION].x = _scale_curve_sample_value_x
			ScaleModifyMethod.ADDITION_OVER_TIME:
				match scale_process_mode_x:
					ProcessMode.PHYSICS:
						if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
							return behavior_values
						_new_scale_value.x = _scale_curve_sample_value_x * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
					ProcessMode.TICKS:
						_new_scale_value.x = _scale_curve_sample_value_x
				behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = _value + Vector2.ONE * _new_scale_value
			ScaleModifyMethod.MULTIPLICATION:
				behavior_values[ProjectileEngine.ScaleModify.SCALE_MULTIPLY] = _value * _scale_curve_sample_value_x
			ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
				behavior_values[ProjectileEngine.ScaleModify.BASE_SCALE_MULTIPLY] =  _scale_curve_sample_value_x
			ScaleModifyMethod.OVERRIDE:
				behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] =  _scale_curve_sample_value_x
			null:
				behavior_values
			_:
				behavior_values

		return behavior_values


	# Handle y scale if curve exists
	if scale_curve_y:
		# Calculate sample position based on loop method
		match scale_curve_loop_method_y:
			LoopMethod.ONCE_AND_DONE:
				_scale_curve_sample_y = _context_life_time_second
			LoopMethod.LOOP_FROM_START:
				_scale_curve_sample_y = fmod(_context_life_time_second, scale_curve_y.max_domain)
			LoopMethod.LOOP_FROM_END:
				if sign(pow(-1, int(_context_life_time_second / scale_curve_y.max_domain))) > 0:
					_scale_curve_sample_y = fmod(_context_life_time_second, scale_curve_y.max_domain)
				else:
					_scale_curve_sample_y = scale_curve_y.max_domain - fmod(_context_life_time_second, scale_curve_y.max_domain)
		
		match scale_modify_method_y:
			ScaleModifyMethod.ADDITION:
				behavior_values[
					ProjectileEngine.ScaleModify.SCALE_ADDITION].y = _scale_curve_sample_value_y
			ScaleModifyMethod.ADDITION_OVER_TIME:
				match scale_process_mode_y:
					ProcessMode.PHYSICS:
						if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
							return behavior_values
						_new_scale_value.y = _scale_curve_sample_value_y * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
					ProcessMode.TICKS:
						_new_scale_value.y = _scale_curve_sample_value_y
				behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = _value + Vector2.ONE * _new_scale_value
			ScaleModifyMethod.MULTIPLICATION:
				behavior_values[ProjectileEngine.ScaleModify.SCALE_MULTIPLY] = _value * _scale_curve_sample_value_y
			ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
				behavior_values[ProjectileEngine.ScaleModify.BASE_SCALE_MULTIPLY] =  _scale_curve_sample_value_y
			ScaleModifyMethod.OVERRIDE:
				behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] =  _scale_curve_sample_value_y
			null:
				behavior_values
			_:
				behavior_values

		return behavior_values
	
	return behavior_values
