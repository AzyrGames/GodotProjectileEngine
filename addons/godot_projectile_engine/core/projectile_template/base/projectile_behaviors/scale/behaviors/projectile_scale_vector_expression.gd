extends ProjectileBehaviorScale
class_name ProjectileScaleVectorExpression

## Behavior that modifies projectile scale using separate mathematical expressions for x and y components.
##
## Allows defining custom scale behavior through mathematical expressions.
## The expressions can use the specified variable (default 't') which represents
## either time or distance based on sample_method.

## What value to use for the expression variable (time/distance/etc)
@export var scale_expression_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
## Variable name to use in the expression (default 't')
@export var scale_expression_variable : String = "t"

@export_group("X Scale Expression")
## How the x expression result modifies scale (add/multiply/override)
@export var scale_modify_method_x : ScaleModifyMethod = ScaleModifyMethod.OVERRIDE
## Mathematical expression defining x scale behavior e.g. [code]sin(t) * 2[/code]
@export_multiline var scale_expression_x : String

@export_group("Y Scale Expression")
## How the y expression result modifies scale (add/multiply/override)
@export var scale_modify_method_y : ScaleModifyMethod = ScaleModifyMethod.OVERRIDE
## Mathematical expression defining y scale behavior e.g. [code]cos(t) * 2[/code]
@export_multiline var scale_expression_y : String

var _expression_x : Expression
var _expression_y : Expression
var _result_value : Vector2

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND,
	]

func _init() -> void:
	# Initialize expression parsers
	_expression_x = Expression.new()
	_expression_y = Expression.new()

## Processes scale behavior by evaluating the expressions
func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {}

	# Get current time/distance value for expression
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float

	# Initialize result with original value
	var result := _value
	
	# Handle x scale if expression exists
	if scale_expression_x:
		# Parse and execute x expression
		_expression_x.parse(scale_expression_x, [scale_expression_variable])
		var _result_x = _expression_x.execute([_context_life_time_second])
		
		if not _expression_x.has_execute_failed() and _result_x is float:
			match scale_modify_method_x:
				ScaleModifyMethod.ADDITION:
					if _scale_behavior_values.has("scale_overwrite"):
						_scale_behavior_values["scale_overwrite"].x = _value.x + _result_x
					else:
						_scale_behavior_values["scale_overwrite"] = Vector2(_value.x + _result_x, _value.y) 
				ScaleModifyMethod.ADDITION_OVER_BASE:
					if _scale_behavior_values.has("scale_addition"):
						_scale_behavior_values["scale_addition"].x = _result_x
					else:
						_scale_behavior_values["scale_addition"] = Vector2(_result_x, 0) 
				ScaleModifyMethod.MULTIPLICATION:
					if _scale_behavior_values.has("scale_overwrite"):
						_scale_behavior_values["scale_overwrite"].x = _value.x * _result_x
					else:
						_scale_behavior_values["scale_overwrite"] = Vector2(_value.x * _result_x, _value.y) 
				ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
					if _scale_behavior_values.has("scale_multiply"):
						_scale_behavior_values["scale_multiply"].x = _result_x
					else:
						_scale_behavior_values["scale_multiply"] = Vector2(_result_x, 0) 
				ScaleModifyMethod.OVERRIDE:
					if _scale_behavior_values.has("scale_overwrite"):
						_scale_behavior_values["scale_overwrite"].x = _result_x
					else:
						_scale_behavior_values["scale_overwrite"] = Vector2(_result_x, _value.y) 
				null:
					pass
				_:
					pass
	
	# Handle y scale if expression exists
	if scale_expression_y:
		# Parse and execute y expression
		_expression_y.parse(scale_expression_y, [scale_expression_variable])
		var _result_y = _expression_y.execute([_context_life_time_second])
		
		if not _expression_y.has_execute_failed() and _result_y is float:
			match scale_modify_method_y:
				ScaleModifyMethod.ADDITION:
					if _scale_behavior_values.has("scale_overwrite"):
						_scale_behavior_values["scale_overwrite"].y = _value.y + _result_y
					else:
						_scale_behavior_values["scale_overwrite"] = Vector2(_value.x, _value.y + _result_y) 
				ScaleModifyMethod.ADDITION_OVER_BASE:
					if _scale_behavior_values.has("scale_addition"):
						_scale_behavior_values["scale_addition"].y = _result_y
					else:
						_scale_behavior_values["scale_addition"] = Vector2(_result_y, 0) 
				ScaleModifyMethod.MULTIPLICATION:
					if _scale_behavior_values.has("scale_overwrite"):
						_scale_behavior_values["scale_overwrite"].y = _value.y * _result_y
					else:
						_scale_behavior_values["scale_overwrite"] = Vector2( _value.x, _value.y * _result_y,) 
				ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
					if _scale_behavior_values.has("scale_multiply"):
						_scale_behavior_values["scale_multiply"].y = _result_y
					else:
						_scale_behavior_values["scale_multiply"] = Vector2(0, _result_y) 
				ScaleModifyMethod.OVERRIDE:
					if _scale_behavior_values.has("scale_overwrite"):
						_scale_behavior_values["scale_overwrite"].y = _result_y
					else:
						_scale_behavior_values["scale_overwrite"] = Vector2(_value.x, _result_y) 
				null:
					pass
				_:
					pass
	
	return _scale_behavior_values
