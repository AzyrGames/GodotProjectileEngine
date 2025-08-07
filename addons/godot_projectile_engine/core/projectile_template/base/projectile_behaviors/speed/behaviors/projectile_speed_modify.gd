extends ProjectileBehaviorSpeed
class_name ProjectileSpeedModify


@export var speed_modify_value : float
@export var speed_modify_method : SpeedModifyMethod

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA
	]

## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	_speed_behavior_values.clear()
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			_speed_behavior_values[ProjectileEngine.SpeedModify.SPEED_ADDITION] = speed_modify_value

		SpeedModifyMethod.ADDITION_OVER_TIME:
			_speed_behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value + speed_modify_value \
				* _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)

		SpeedModifyMethod.MULTIPLICATION:
			_speed_behavior_values[ProjectileEngine.SpeedModify.SPEED_MULTIPLY] = speed_modify_value

		SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
			_speed_behavior_values[ProjectileEngine.SpeedModify.BASE_SPEED_MULTIPLY] =  speed_modify_value

		SpeedModifyMethod.OVERRIDE:
			_speed_behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = speed_modify_value

		null:
			_speed_behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value

		_:
			_speed_behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value

	return _speed_behavior_values
