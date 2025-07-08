extends ProjectileBehaviorSpeed
class_name ProjectileSpeedModify


@export var speed_modify_value : float
@export var speed_modify_method : SpeedModifyMethod

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return []

var speed_behavior_values : Dictionary = {}

## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			speed_behavior_values["speed_overwrite"] = _value + speed_modify_value

		SpeedModifyMethod.ADDITION_OVER_BASE:
			speed_behavior_values["speed_addition"] = speed_modify_value

		SpeedModifyMethod.MULTIPLICATION:
			speed_behavior_values["speed_overwrite"] = _value * speed_modify_value

		SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
			speed_behavior_values["speed_multiply"] =  speed_modify_value

		SpeedModifyMethod.OVERRIDE:
			speed_behavior_values["speed_overwrite"] = speed_modify_value

		null:
			speed_behavior_values["speed_overwrite"] = _value
		_:
			speed_behavior_values["speed_overwrite"] = _value
			
	return speed_behavior_values
