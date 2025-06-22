extends ProjectileBehaviorDirection
class_name ProjectileDirectionExpression

## Behavior that modifies projectile direction using a mathematical expression.
##
## Allows defining custom direction behavior through mathematical expressions.
## The expression can use the specified variable (default 't') which represents
## either time or distance based on sample_method.

## What value to use for the expression variable (time/distance/etc)
@export var direction_expression_sample_method: SampleMethod = SampleMethod.LIFE_TIME_SECOND
## How the expression result modifies direction (add/multiply/override)
@export var direction_modify_method: DirectionModifyMethod = DirectionModifyMethod.OVERRIDE
## Variable name to use in the expression (default 't')
@export var expression_streght : float = 0.5
@export var direction_expression_variable: String = "t"
## Mathematical expression defining direction behavior e.g. `Vector2(cos(t), sin(t))`
@export_multiline var direction_x_expression: String
@export_multiline var direction_y_expression: String


var _expression_x: Expression
var _expression_y: Expression

var _parse_value : Vector2

var _result_value: Vector2

## Returns required context values for this behavior
func _request_behavior_context() -> Array:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
		ProjectileEngine.BehaviorContext.BASE_DIRECTION
	]

func _init() -> void:
	_expression_x = Expression.new()
	_expression_y = Expression.new()


## Processes direction behavior by evaluating the expression
func process_behavior(value: Vector2, context: Dictionary) -> Array:
	# Parse the expression with our variable
	# print(_expression_x)
	# print(direction_x_expression)
	# print(direction_expression_variable)
	_expression_x.parse(direction_x_expression, [direction_expression_variable])
	if _expression_x.parse(direction_x_expression, [direction_expression_variable]) != OK:
		push_error("Failed to parse direction expression: " + _expression_x.get_error_text())
		return [value]

	if _expression_y.parse(direction_y_expression, [direction_expression_variable]) != OK:
		push_error("Failed to parse direction expression: " + _expression_y.get_error_text())
		return [value]


	# Return original value if required context is missing
	if not context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return [value]

	# Get current time/distance value for expression
	var current_value: float = context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)

	# Execute expression with current value
	var _result_x = _expression_x.execute([current_value])
	# Fallback to original value if expression fails or returns wrong type
	if _expression_x.has_execute_failed():
		return [value]
	_parse_value.x = _result_x

	var _result_y = _expression_y.execute([current_value])
	# Fallback to original value if expression fails or returns wrong type
	if _expression_y.has_execute_failed():
		return [value]

	_parse_value.y = _result_y

	match direction_modify_method:
		## Yes, also need to track track every behaviors that modify the direction but....
		DirectionModifyMethod.ROTATION:
			return [value, _parse_value.angle()]
			pass
		# Later ha, to complicated, need to track every behaviors that modify the addition.
		DirectionModifyMethod.ADDITION:
			if _parse_value == Vector2.ZERO: 
				return [value]
			return [value, 0.0, _parse_value * expression_streght]
		DirectionModifyMethod.OVERRIDE:
			return [_parse_value]
		_:
			[value]

	return [_result_value]
