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
## Variable name to use in the expression (default 't')
@export var scale_expression_variable : String = "t"
## Mathematical expression defining scale behavior e.g. [code]sin(t) * 2[/code]
@export_multiline var scale_expression : String

var _scale_expression_result : Variant
var _expression : Expression
var _result_value : Vector2

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

	# Apply expression result based on modification method
	match scale_modify_method:
		ScaleModifyMethod.ADDITION:
			return {"scale_overwrite" : _value + Vector2.ONE * _scale_expression_result}
		ScaleModifyMethod.ADDITION_OVER_BASE:
			return {"scale_addition" : Vector2.ONE * _scale_expression_result}
		ScaleModifyMethod.MULTIPLICATION:
			return {"scale_overwrite" : _value * _scale_expression_result}
		ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
			return {"scale_multiply" : Vector2.ONE * _scale_expression_result}
		ScaleModifyMethod.OVERRIDE:
			return {"scale_overwrite" : Vector2.ONE * _scale_expression_result}
		null:
			{}
		_:
			{}

	return {}
