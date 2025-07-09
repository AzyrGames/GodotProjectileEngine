extends ProjectileBehaviorRotation
class_name ProjectileRotationExpression

## Behavior that modifies projectile rotation using a mathematical expression.
##
## Allows defining custom rotation behavior through mathematical expressions.
## The expression can use the specified variable (default 't') which represents
## either time or distance based on sample_method.

## What value to use for the expression variable (time/distance/etc)
@export var rotation_expression_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## How the expression result modifies rotation (add/multiply/override)
@export var rotation_modify_method : RotationModifyMethod = RotationModifyMethod.OVERRIDE
## Variable name to use in the expression (default 't')
@export var rotation_expression_variable : String = "t"
## Mathematical expression defining rotation behavior e.g. [code]sin(t) * 100[/code]
@export_multiline var rotation_expression : String

var _rotation_expression_result : Variant
var _expression : Expression
var _result_value : float

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
	]


func _init() -> void:
	# Initialize expression parser
	_expression = Expression.new()


## Processes rotation behavior by evaluating the expression
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	# Parse the expression with our variable
	_expression.parse(rotation_expression, [rotation_expression_variable])

	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {}

	# Get current time/distance value for expression
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float

	# Execute expression with current value
	_rotation_expression_result = _expression.execute([_context_life_time_second])
	
	# Fallback to original value if expression fails
	if _expression.has_execute_failed() or _rotation_expression_result is not float:
		return {}

	match rotation_modify_method:
		RotationModifyMethod.ADDITION:
			return {"rotation_overwrite" : _value + _rotation_expression_result}
		RotationModifyMethod.ADDITION_OVER_BASE:
			return {"rotation_addition" : _rotation_expression_result}
		RotationModifyMethod.MULTIPLICATION:
			return {"rotation_overwrite" :_value * _rotation_expression_result}
		RotationModifyMethod.MULTIPLICATION_OVER_BASE:
			return {"rotation_multiply" :_rotation_expression_result}
		RotationModifyMethod.OVERRIDE:
			return {"rotation_overwrite" :_rotation_expression_result}
		null:
			{}
		_:
			{}

	return {}
