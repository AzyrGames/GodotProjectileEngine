extends ProjectileBehaviorDirection
class_name ProjectileDirectionModify

@export var direction_modify_value : Vector2 = Vector2.RIGHT
# @export var direction_modify_strenght : float = 0.5
# @export var direction_normalize : bool = true
@export var direction_modify_method: DirectionModifyMethod = DirectionModifyMethod.ROTATION


## Requests required context _values
func _request_behavior_context() -> Array:
	return []


func _request_persist_behavior_context() -> Array:
	return []


## Processes direction behavior with random walk
func process_behavior(_value: Vector2, _component_context: Dictionary) -> Dictionary:
	_direction_behavior_values.clear()
	match direction_modify_method:
		DirectionModifyMethod.ROTATION:
			if direction_normalize:
				_direction_behavior_values[
					ProjectileEngine.DirectionModify.DIRECTION_ROTATION] = direction_modify_value.normalized().angle()
			else:
				_direction_behavior_values[
					ProjectileEngine.DirectionModify.DIRECTION_ROTATION] = direction_modify_value.angle()
		DirectionModifyMethod.ADDITION:
			if direction_normalize:
				_direction_behavior_values[
					ProjectileEngine.DirectionModify.DIRECTION_ADDITION] = (direction_modify_value.normalized())
			else:
				_direction_behavior_values[
					ProjectileEngine.DirectionModify.DIRECTION_ADDITION] = direction_modify_value
		DirectionModifyMethod.OVERRIDE:
			_direction_behavior_values[
				ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE] = direction_modify_value.normalized()
		_:
			pass

	return _direction_behavior_values