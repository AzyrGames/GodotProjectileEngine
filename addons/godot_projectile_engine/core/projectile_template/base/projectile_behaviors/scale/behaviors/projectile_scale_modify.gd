extends ProjectileBehaviorScale
class_name ProjectileScaleModify



@export var scale_modify_value : float = 0.0
@export var scale_process_mode : ScaleProcessMode = ScaleProcessMode.TICKS
@export var scale_modify_method: ScaleModifyMethod = ScaleModifyMethod.ADDITION

var _new_scale_value : float 

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	match scale_process_mode:
		ScaleProcessMode.PHYSICS:
			return [
				ProjectileEngine.BehaviorContext.PHYSICS_DELTA
			]
			pass
		ScaleProcessMode.TICKS:
			pass
	return []


func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	match scale_process_mode:
		ScaleProcessMode.PHYSICS:
			if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
				return {}
			_new_scale_value = scale_modify_value * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)

		ScaleProcessMode.TICKS:
			_new_scale_value = scale_modify_value

	match scale_modify_method:
		ScaleModifyMethod.ADDITION:
			return {"scale_overwrite" : _value + Vector2.ONE * _new_scale_value}
		ScaleModifyMethod.ADDITION_OVER_BASE:
			return {"scale_addition" : Vector2.ONE * scale_modify_value}
		ScaleModifyMethod.MULTIPLICATION:
			return {"scale_overwrite" : _value * _new_scale_value}
		ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
			return {"scale_multiply" : Vector2.ONE * scale_modify_value}
		ScaleModifyMethod.OVERRIDE:
			return {"scale_overwrite" : Vector2.ONE * _new_scale_value}
		null:
			{}
		_:
			{}

	return {}
