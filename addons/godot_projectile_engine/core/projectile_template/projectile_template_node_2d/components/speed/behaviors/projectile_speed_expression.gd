extends ProjectileBehaviorSpeed
class_name ProjectileSpeedExpression


@export var speed_expression_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
@export var speed_modify_method : SpeedModifyMethod = SpeedModifyMethod.OVERRIDE

@export var speed_expression_variable : String = "t"

@export_multiline var speed_expression : String

var _speed_expression_result : Variant

var _expression : Expression
var _result_value : float


func behavior_context_request() -> Array[ProjectileEngine.BehviorContext]:
	return [
		ProjectileEngine.BehviorContext.LIFE_TIME_SECOND,
		ProjectileEngine.BehviorContext.BASE_SPEED
		]
	pass


func _init() -> void:
	_expression = Expression.new()


func process_behavior(_value: float, _context: Dictionary) -> float:
	_expression.parse(speed_expression, [speed_expression_variable])

	if not _context.has(ProjectileEngine.BehviorContext.LIFE_TIME_SECOND): return _value
	var _context_life_time_second := _context.get(ProjectileEngine.BehviorContext.LIFE_TIME_SECOND) as float

	_speed_expression_result = _expression.execute([_context_life_time_second])
	if _expression.has_execute_failed():
		return _value

	if _speed_expression_result is not float:
		return _value

	match speed_modify_method:
		SpeedModifyMethod.ADDTITION:
			if !_context.has(ProjectileEngine.BehviorContext.BASE_SPEED): _result_value = _value
			_result_value = _value + _speed_expression_result
			pass
		SpeedModifyMethod.MULTIPLIER:
			if !_context.has(ProjectileEngine.BehviorContext.BASE_SPEED): _result_value = _value
			_result_value = _context.get(ProjectileEngine.BehviorContext.BASE_SPEED) * _speed_expression_result
			pass
		SpeedModifyMethod.OVERRIDE:
			_result_value = _speed_expression_result
			pass

	return _result_value
