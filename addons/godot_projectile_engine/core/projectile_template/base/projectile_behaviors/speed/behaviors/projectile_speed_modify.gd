extends ProjectileBehaviorSpeed
class_name ProjectileSpeedModify


@export var speed_modify_value : float
@export var speed_process_mode : ProcessMode
@export var speed_modify_method : SpeedModifyMethod

var _new_speed_value : float

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA,
	]

## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	behavior_values.clear()
	match speed_modify_method:
		SpeedModifyMethod.ADDITION:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_ADDITION] = speed_modify_value

		SpeedModifyMethod.ADDITION_OVER_TIME:
			match speed_process_mode:
				ProcessMode.PHYSICS:
					if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
						return behavior_values
					_new_speed_value = deg_to_rad(speed_modify_value) * _context.get(
						ProjectileEngine.BehaviorContext.PHYSICS_DELTA
						)
				ProcessMode.TICKS:
					_new_speed_value = deg_to_rad(speed_modify_value)
			behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value + speed_modify_value

		SpeedModifyMethod.MULTIPLICATION:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_MULTIPLY] = speed_modify_value

		SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
			behavior_values[ProjectileEngine.SpeedModify.BASE_SPEED_MULTIPLY] =  speed_modify_value

		SpeedModifyMethod.OVERRIDE:
			behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = speed_modify_value

		null:
			behavior_values

		_:
			behavior_values

	return behavior_values
