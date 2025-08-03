extends ProjectileBehaviorDirection
class_name ProjectileDirectionModify

@export var direction_modify_value : Vector2 = Vector2.RIGHT
@export var direction_modify_strenght : float = 0.5
@export var direction_modify_method: DirectionModifyMethod


## Requests required context _values
func _request_behavior_context() -> Array:
	return []


func _request_persist_behavior_context() -> Array:
	return []


## Processes direction behavior with random walk
func process_behavior(_value: Vector2, _component_context: Dictionary) -> Dictionary:
	# Get delta time from _context
	match direction_modify_method:
		DirectionModifyMethod.ROTATION:
			_direction_behavior_values["direction_rotation"] = direction_modify_value.angle()
		DirectionModifyMethod.ADDITION:
			_direction_behavior_values["direction_addition"] = (direction_modify_value * direction_modify_strenght)
		DirectionModifyMethod.OVERRIDE:
			_direction_behavior_values["direction_overwrite"] = (direction_modify_value * direction_modify_strenght)
		_:
			_direction_behavior_values["direction_overwrite"] = _value

	return _direction_behavior_values