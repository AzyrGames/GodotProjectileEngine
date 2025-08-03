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
				return {}
			_new_rotation_value = rotation_modify_value * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)

		RotationProcessMode.TICKS:
			_new_rotation_value = rotation_modify_value


	match rotation_modify_method:
		RotationModifyMethod.ADDITION:
			return {"rotation_overwrite" : _value + deg_to_rad(_new_rotation_value)}
		RotationModifyMethod.ADDITION_OVER_BASE:
			return {"rotation_addition" : deg_to_rad(rotation_modify_value)}
		RotationModifyMethod.MULTIPLICATION:
			return {"rotation_overwrite" : _value * _new_rotation_value}
		RotationModifyMethod.MULTIPLICATION_OVER_BASE:
			return {"rotation_multiply" : deg_to_rad(rotation_modify_value)}
		RotationModifyMethod.OVERRIDE:
			return {"rotation_overwrite" :deg_to_rad(_new_rotation_value)}
		null:
			{}
		_:
			{}

	return {}


