extends ProjectileBehaviorScale
class_name ProjectileScaleModify



@export var scale_modify_value : float = 0.0
@export var scale_process_mode : ProcessMode = ProcessMode.TICKS
@export var scale_modify_method: ScaleModifyMethod = ScaleModifyMethod.ADDITION

var _new_scale_value : float 

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA,
	]

func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	behavior_values.clear()
	match scale_process_mode:
		ProcessMode.PHYSICS:
			if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
				return {}
			_new_scale_value = scale_modify_value * _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)

		ProcessMode.TICKS:
			_new_scale_value = scale_modify_value

	match scale_modify_method:
		ScaleModifyMethod.ADDITION:
			behavior_values[
				ProjectileEngine.ScaleModify.SCALE_ADDITION] = Vector2.ONE * _new_scale_value
			# return { : _value + Vector2.ONE * _new_scale_value}
		ScaleModifyMethod.ADDITION_OVER_TIME:
			return {ProjectileEngine.ScaleModify.SCALE_ADDITION : Vector2.ONE * scale_modify_value}
		ScaleModifyMethod.MULTIPLICATION:
			return {ProjectileEngine.ScaleModify.SCALE_OVERWRITE : _value * _new_scale_value}
		ScaleModifyMethod.MULTIPLICATION_OVER_BASE:
			return {ProjectileEngine.ScaleModify.SCALE_MULTIPLY : Vector2.ONE * scale_modify_value}
		ScaleModifyMethod.OVERRIDE:
			return {ProjectileEngine.ScaleModify.SCALE_OVERWRITE : Vector2.ONE * _new_scale_value}
		null:
			{}
		_:
			{}

	return {}


	# behavior_values.clear()
	# match speed_modify_method:
	# 	SpeedModifyMethod.ADDITION:
	# 		behavior_values[ProjectileEngine.SpeedModify.SPEED_ADDITION] = speed_modify_value

	# 	SpeedModifyMethod.ADDITION_OVER_TIME:
	# 		behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value + speed_modify_value \
	# 			* _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)

	# 	SpeedModifyMethod.MULTIPLICATION:
	# 		behavior_values[ProjectileEngine.SpeedModify.SPEED_MULTIPLY] = speed_modify_value

	# 	SpeedModifyMethod.MULTIPLICATION_OVER_BASE:
	# 		behavior_values[ProjectileEngine.SpeedModify.BASE_SPEED_MULTIPLY] =  speed_modify_value

	# 	SpeedModifyMethod.OVERRIDE:
	# 		behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = speed_modify_value

	# 	null:
	# 		behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value

	# 	_:
	# 		behavior_values[ProjectileEngine.SpeedModify.SPEED_OVERWRITE] = _value

	# return behavior_values