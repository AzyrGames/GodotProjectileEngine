extends ProjectileBehaviorSpeed
class_name ProjectileSpeedExpression

## Behavior that modifies projectile speed using a mathematical expression.
##
## Allows defining custom speed behavior through mathematical expressions.
## The expression can use the specified variable (default 't') which represents
## either time or distance based on sample_method.

## What value to use for the expression variable (time/distance/etc)
@export var speed_expression_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## How the expression result modifies speed (add/multiply/override)
@export var speed_modify_method : SpeedModifyMethod = SpeedModifyMethod.OVERRIDE
## Variable name to use in the expression (default 't')
@export var speed_expression_variable : String = "t"
## Mathematical expression defining speed behavior e.g. [code]sin(t) * 100[/code]
@export_multiline var speed_expression : String

var _speed_expression_result : Variant
var _expression : Expression
var _result_value : float

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
		ProjectileEngine.BehaviorContext.BASE_SPEED
	]


func _init() -> void:
	# Initialize expression parser
	_expression = Expression.new()


## Processes speed behavior by evaluating the expression
func process_behavior(_value: float, _context: Dictionary) -> float:
	# Parse the expression with our variable
	_expression.parse(speed_expression, [speed_expression_variable])

	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return _value

	# Get current time/distance value for expression
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float

	# Execute expression with current value
	_speed_expression_result = _expression.execute([_context_life_time_second])
	
	# Fallback to original value if expression fails
	if _expression.has_execute_failed() or _speed_expression_result is not float:
		return _value

	# Apply expression result based on modification method
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			if !_context.has(ProjectileEngine.BehaviorContext.BASE_SPEED): 
				_result_value = _value
			else:
				_result_value = _value + _speed_expression_result
		SpeedModifyMethod.MULTIPLICATION:
			if !_context.has(ProjectileEngine.BehaviorContext.BASE_SPEED): 
				_result_value = _value
			else:
				_result_value = _context.get(ProjectileEngine.BehaviorContext.BASE_SPEED) * _speed_expression_result
		SpeedModifyMethod.OVERRIDE:
			_result_value = _speed_expression_result

	return _result_value
