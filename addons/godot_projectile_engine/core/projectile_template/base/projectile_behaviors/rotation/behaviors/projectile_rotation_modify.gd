extends ProjectileBehaviorRotation
class_name ProjectileRotationModify

## Make rotation follow the angle of the Direction.


@export_custom(PROPERTY_HINT_NONE, "suffix:°") var rotation_modify_value : float = 0.0
@export var rotation_process_mode : RotationProcessMode = RotationProcessMode.TICKS
@export var rotation_modify_method: RotationModifyMethod = RotationModifyMethod.ADDITION

var _new_rotation_value : float 

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	match rotation_process_mode:
		RotationProcessMode.PHYSICS:
			return [
				ProjectileEngine.BehaviorContext.PHYSICS_DELTA
			]
			pass
		RotationProcessMode.TICKS:
			pass
	return []


func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	match rotation_process_mode:
		RotationProcessMode.PHYSICS:
			if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
				return _rotation_behavior_values
			_new_rotation_value = deg_to_rad(rotation_modify_value) * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)

		RotationProcessMode.TICKS:
			_new_rotation_value = deg_to_rad(rotation_modify_value)

	_rotation_behavior_values.clear()
	match rotation_modify_method:
		RotationModifyMethod.ADDITION:
			_rotation_behavior_values[ProjectileEngine.RotationModify.ROTATION_ADDITION] =  deg_to_rad(rotation_modify_value)
		RotationModifyMethod.ADDITION_OVER_TIME:
			_rotation_behavior_values[ProjectileEngine.RotationModify.ROTATION_OVERWRITE] = _value + _new_rotation_value
		RotationModifyMethod.OVERRIDE:
			_rotation_behavior_values[ProjectileEngine.RotationModify.ROTATION_OVERWRITE] = deg_to_rad(rotation_modify_value)
		null:
			_rotation_behavior_values
		_:
			_rotation_behavior_values

	return _rotation_behavior_values


