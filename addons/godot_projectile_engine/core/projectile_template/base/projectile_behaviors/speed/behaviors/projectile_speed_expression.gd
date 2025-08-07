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
@export var speed_process_mode : ProcessMode
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
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA
	]


func _init() -> void:
	# Initialize expression parser
	_expression = Expression.new()


## Processes speed behavior by evaluating the expression
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	# Parse the expression with our variable
	behavior_values.clear()
	_expression.parse(speed_expression, [speed_expression_variable])

	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {ProjectileEngine.SpeedModify.SPEED_OVERWRITE : _value}

	# Get current time/distance value for expression
	_context_life_time_second = _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)

	# Execute expression with current value
	_speed_expression_result = _expression.execute([_context_life_time_second])
	
	# Fallback to original value if expression fails
	if _expression.has_execute_failed() or _speed_expression_result is not float:
		return {ProjectileEngine.SpeedModify.SPEED_OVERWRITE : _value}

	# Apply expression result based on modification method
	behavior_values.clear()
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_ADDITION] = _speed_expression_result

		SpeedModifyMethod.ADDITION_OVER_TIME:
			match speed_process_mode:
				ProcessMode.PHYSICS:
					behavior_values[
						ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value + _speed_expression_result \
						* _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
				ProcessMode.TICKS:
					behavior_values[
						ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value + _speed_expression_result

		SpeedModifyMethod.MULTIPLICATION:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_MULTIPLY] = _speed_expression_result

		SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
			behavior_values[ProjectileEngine.SpeedModify.BASE_SPEED_MULTIPLY] =  _speed_expression_result

		SpeedModifyMethod.OVERRIDE:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _speed_expression_result

		null:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value

		_:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value

	return behavior_values