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
@export var scale_process_mode_x : ProcessMode
## Mathematical expression defining x scale behavior e.g. [code]sin(t) * 2[/code]
@export_multiline var scale_expression_x : String

@export_group("Y Scale Expression")
## How the y expression result modifies scale (add/multiply/override)
@export var scale_modify_method_y : ScaleModifyMethod = ScaleModifyMethod.OVERRIDE
@export var scale_process_mode_y : ProcessMode

## Mathematical expression defining y scale behavior e.g. [code]cos(t) * 2[/code]
@export_multiline var scale_expression_y : String

var _expression_x : Expression
var _expression_y : Expression
var _result_value : Vector2
var _new_scale_value : Vector2

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
	behavior_values.clear()
	# Return original value if required context is missing
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND): 
		return {}

	# Get current time/distance value for expression
	var _context_life_time_second := _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) as float
	# Handle y scale expression exists
	if scale_expression_x:
		# Parse and execute x expression
		_expression_x.parse(scale_expression_x, [scale_expression_variable])
		var _result_x = _expression_x.execute([_context_life_time_second])

		match scale_modify_method_x:
			ScaleModifyMethod.ADDITION:
				behavior_values[
					ProjectileEngine.ScaleModify.SCALE_ADDITION].x = _result_x
			ScaleModifyMethod.ADDITION_OVER_TIME:
				match scale_process_mode_x:
					ProcessMode.PHYSICS:
						if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
							return behavior_values
						_new_scale_value.x = _result_x * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
					ProcessMode.TICKS:
						_new_scale_value.x = _result_x
				behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = _value + Vector2.ONE * _new_scale_value
			ScaleModifyMethod.MULTIPLICATION:
				behavior_values[ProjectileEngine.ScaleModify.SCALE_MULTIPLY] = _value * _result_x
			ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
				behavior_values[ProjectileEngine.ScaleModify.BASE_SCALE_MULTIPLY] =  _result_x
			ScaleModifyMethod.OVERRIDE:
				behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] =  _result_x
			null:
				behavior_values
			_:
				behavior_values

	# Handle y scale expression exists
	if scale_expression_y:
		# Parse and execute y expression
		_expression_y.parse(scale_expression_y, [scale_expression_variable])
		var _result_y = _expression_y.execute([_context_life_time_second])
		
		match scale_modify_method_y:
			ScaleModifyMethod.ADDITION:
				behavior_values[
					ProjectileEngine.ScaleModify.SCALE_ADDITION].y = _result_y
			ScaleModifyMethod.ADDITION_OVER_TIME:
				match scale_process_mode_y:
					ProcessMode.PHYSICS:
						if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
							return behavior_values
						_new_scale_value.y = _result_y * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
					ProcessMode.TICKS:
						_new_scale_value.y = _result_y
				behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = _value + Vector2.ONE * _new_scale_value
			ScaleModifyMethod.MULTIPLICATION:
				behavior_values[ProjectileEngine.ScaleModify.SCALE_MULTIPLY] = _value * _result_y
			ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
				behavior_values[ProjectileEngine.ScaleModify.BASE_SCALE_MULTIPLY] =  _result_y
			ScaleModifyMethod.OVERRIDE:
				behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] =  _result_y
			null:
				behavior_values
			_:
				behavior_values
	
	return behavior_values
