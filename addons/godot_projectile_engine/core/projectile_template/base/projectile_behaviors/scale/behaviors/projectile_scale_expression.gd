extends ProjectileBehaviorScale
class_name ProjectileScaleExpression

## Behavior that modifies projectile scale using a mathematical expression.
##
## Allows defining custom scale behavior through mathematical expressions.
## The expression can use the specified variable (default 't') which represents
## either time or distance based on sample_method.

## What value to use for the expression variable (time/distance/etc)
@export var scale_expression_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## How the expression result modifies scale (add/multiply/override)
@export var scale_modify_method : ScaleModifyMethod = ScaleModifyMethod.OVERRIDE
@export var scale_process_mode : ProcessMode
## Variable name to use in the expression (default 't')
@export var scale_expression_variable : String = "t"
## Mathematical expression defining scale behavior e.g. [code]sin(t) * 2[/code]
@export_multiline var scale_expression : String

var _scale_expression_result : Variant
var _expression : Expression
var _result_value : Vector2
var _new_scale_value : float


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
	]

func _init() -> void:
	# Initialize expression parser
	_expression = Expression.new()

## Processes scale behavior by evaluating the expression
func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	# Parse the expression with our variable
	_expression.parse(scale_expression, [scale_expression_variable])

	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {}

	# Get current time/distance value for expression
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float

	# Execute expression with current value
	_scale_expression_result = _expression.execute([_context_life_time_second])
	
	# Fallback to original value if expression fails
	if _expression.has_execute_failed() or _scale_expression_result is not float:
		return {}

	behavior_values.clear()
	match scale_modify_method:
		ScaleModifyMethod.ADDITION:
			behavior_values[
				ProjectileEngine.ScaleModify.SCALE_ADDITION] = Vector2.ONE * _scale_expression_result
		ScaleModifyMethod.ADDITION_OVER_TIME:
			match scale_process_mode:
				ProcessMode.PHYSICS:
					if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
						return behavior_values
					_new_scale_value = _scale_expression_result * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
				ProcessMode.TICKS:
					_new_scale_value = _scale_expression_result
			behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = _value + Vector2.ONE * _new_scale_value
		ScaleModifyMethod.MULTIPLICATION:
			behavior_values[ProjectileEngine.ScaleModify.SCALE_MULTIPLY] = _value * _scale_expression_result
		ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
			behavior_values[ProjectileEngine.ScaleModify.BASE_SCALE_MULTIPLY] =  Vector2.ONE * _scale_expression_result
		ScaleModifyMethod.OVERRIDE:
			behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] =  Vector2.ONE * _scale_expression_result
		null:
			behavior_values
		_:
			behavior_values

	return behavior_values