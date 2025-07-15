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
## How the x curve loops over time
@export var scale_curve_loop_method_x : LoopMethod = LoopMethod.ONCE_AND_DONE
## What value to use for sampling the x curve (time/distance/etc)
@export var scale_curve_sample_method_x : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## Curve defining scale modification for x component
@export var scale_curve_x : Curve

@export_group("Y Scale Curve")
## How the y curve value modifies the scale (add/multiply/override)
@export var scale_modify_method_y : ScaleModifyMethod = ScaleModifyMethod.MULTIPLICATION
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
	
	_scale_behavior_values.clear()
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
				if _scale_behavior_values.has("scale_overwrite"):
					_scale_behavior_values["scale_overwrite"].x = _value.x + _scale_curve_sample_value_x
				else:
					_scale_behavior_values["scale_overwrite"] = Vector2(_value.x + _scale_curve_sample_value_x, _value.y) 
			ScaleModifyMethod.ADDITION_OVER_BASE:
				if _scale_behavior_values.has("scale_addition"):
					_scale_behavior_values["scale_addition"].x = _scale_curve_sample_value_x
				else:
					_scale_behavior_values["scale_addition"] = Vector2(_scale_curve_sample_value_x, 0) 
				result.x = _scale_curve_sample_value_x
			ScaleModifyMethod.MULTIPLICATION:
				if _scale_behavior_values.has("scale_overwrite"):
					_scale_behavior_values["scale_overwrite"].x = _value.x * _scale_curve_sample_value_x
				else:
					_scale_behavior_values["scale_overwrite"] = Vector2(_value.x * _scale_curve_sample_value_x, _value.y) 
				# result.x = _value.x + _scale_curve_sample_value_x
			ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
				if _scale_behavior_values.has("scale_multiply"):
					_scale_behavior_values["scale_multiply"].x = _scale_curve_sample_value_x
				else:
					_scale_behavior_values["scale_multiply"] = Vector2(_scale_curve_sample_value_x, 0) 
			ScaleModifyMethod.OVERRIDE:
				if _scale_behavior_values.has("scale_overwrite"):
					_scale_behavior_values["scale_overwrite"].x = _scale_curve_sample_value_x
				else:
					_scale_behavior_values["scale_overwrite"] = Vector2(_scale_curve_sample_value_x, _value.y) 
			null:
				pass
			_:
				pass

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
		
		# Sample curve and apply modification
		_scale_curve_sample_value_y = scale_curve_y.sample_baked(_scale_curve_sample_y)
		match scale_modify_method_y:
			ScaleModifyMethod.ADDITION:
				if _scale_behavior_values.has("scale_overwrite"):
					_scale_behavior_values["scale_overwrite"].y = _value.y + _scale_curve_sample_value_y
				else:
					_scale_behavior_values["scale_overwrite"] = Vector2(_value.x, _value.y + _scale_curve_sample_value_y) 
			ScaleModifyMethod.ADDITION_OVER_BASE:
				if _scale_behavior_values.has("scale_addition"):
					_scale_behavior_values["scale_addition"].y = _scale_curve_sample_value_y
				else:
					_scale_behavior_values["scale_addition"] = Vector2(_scale_curve_sample_value_y, 0) 
				result.y = _scale_curve_sample_value_y
			ScaleModifyMethod.MULTIPLICATION:
				if _scale_behavior_values.has("scale_overwrite"):
					_scale_behavior_values["scale_overwrite"].y = _value.y * _scale_curve_sample_value_y
				else:
					_scale_behavior_values["scale_overwrite"] = Vector2(_value.x, _value.y * _scale_curve_sample_value_y) 
				# result.y = _value.y + _scale_curve_sample_value_y
			ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
				if _scale_behavior_values.has("scale_multiply"):
					_scale_behavior_values["scale_multiply"].y = _scale_curve_sample_value_y
				else:
					_scale_behavior_values["scale_multiply"] = Vector2(0, _scale_curve_sample_value_y) 
			ScaleModifyMethod.OVERRIDE:
				if _scale_behavior_values.has("scale_overwrite"):
					_scale_behavior_values["scale_overwrite"].y = _scale_curve_sample_value_y
				else:
					_scale_behavior_values["scale_overwrite"] = Vector2(_value.x, _scale_curve_sample_value_y) 
			null:
				pass
			_:
				pass
	
	return _scale_behavior_values
