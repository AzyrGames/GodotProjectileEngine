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
var _context_life_time_second : float
var _speed_expression_result : Variant
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


## Processes speed behavior by evaluating the expression
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	# Parse the expression with our variable
	_expression.parse(speed_expression, [speed_expression_variable])

	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {"speed_overwrite" : _value}

	# Get current time/distance value for expression
	_context_life_time_second = _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)

	# Execute expression with current value
	_speed_expression_result = _expression.execute([_context_life_time_second])
	
	# Fallback to original value if expression fails
	if _expression.has_execute_failed() or _speed_expression_result is not float:
		return {"speed_overwrite" : _value}

	# Apply expression result based on modification method
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			_speed_behavior_values["speed_overwrite"] = _value + _speed_expression_result

		SpeedModifyMethod.ADDITION_OVER_BASE:
			_speed_behavior_values["speed_addition"] = _speed_expression_result

		SpeedModifyMethod.MULTIPLICATION:
			_speed_behavior_values["speed_overwrite"] = _value * _speed_expression_result

		SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
			_speed_behavior_values["speed_multiply"] =  _speed_expression_result

		SpeedModifyMethod.OVERRIDE:
			_speed_behavior_values["speed_overwrite"] = _speed_expression_result
		null:
			_speed_behavior_values["speed_overwrite"] = _value
		_:
			_speed_behavior_values["speed_overwrite"] = _value
			
	return _speed_behavior_values