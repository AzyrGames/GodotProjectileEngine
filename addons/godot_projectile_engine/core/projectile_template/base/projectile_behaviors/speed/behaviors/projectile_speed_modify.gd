extends ProjectileBehaviorSpeed
class_name ProjectileSpeedModify


@export var speed_modify_value : float
@export var speed_modify_method : SpeedModifyMethod

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return []


## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			_speed_behavior_values["speed_overwrite"] = _value + speed_modify_value

		SpeedModifyMethod.ADDITION_OVER_BASE:
			_speed_behavior_values["speed_addition"] = speed_modify_value

		SpeedModifyMethod.MULTIPLICATION:
			_speed_behavior_values["speed_overwrite"] = _value * speed_modify_value

		SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
			_speed_behavior_values["speed_multiply"] =  speed_modify_value

		SpeedModifyMethod.OVERRIDE:
			_speed_behavior_values["speed_overwrite"] = speed_modify_value

		null:
			_speed_behavior_values["speed_overwrite"] = _value
		_:
			_speed_behavior_values["speed_overwrite"] = _value
			
	return _speed_behavior_values
