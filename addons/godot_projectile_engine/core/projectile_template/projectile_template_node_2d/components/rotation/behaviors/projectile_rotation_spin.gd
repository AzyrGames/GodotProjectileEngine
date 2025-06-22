extends ProjectileBehaviorRotation
class_name ProjectileRotationSpin

## Make rotation follow the angle of the Direction.


@export_range(0, 360, 0.1, "radians_as_degrees") var spin_speed : float = 0.0

@export var process_mode : RotationProcessMode = RotationProcessMode.PHYSICS
@export var modify_method: RotationModifyMethod = RotationModifyMethod.ADDTITION


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	match process_mode:
		RotationProcessMode.PHYSICS:
			return [
				ProjectileEngine.BehaviorContext.PHYSICS_DELTA
			]
			pass
		RotationProcessMode.TICKS:
			pass
	return [
	]

var _spin_value : float 

## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> float:
	# print(_value)
	match process_mode:
		RotationProcessMode.PHYSICS:
			if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
				return _value
			_spin_value = spin_speed * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)

		RotationProcessMode.TICKS:
			_spin_value = spin_speed

	match modify_method:
		RotationModifyMethod.ADDTITION:
			return _value + _spin_value

		RotationModifyMethod.OVERRIDE:
			pass
	
	return _value

