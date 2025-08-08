extends ProjectileBehaviorDirection
class_name ProjectileDirectionFollowRotation

## Make direction follow 


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.TEXTURE_ROTATION_FINAL,
	]


var _rotation: float


func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	_direction_behavior_values.clear()
	if !_context.has(ProjectileEngine.BehaviorContext.ROTATION): 
		return _direction_behavior_values
	_rotation = _context.get(ProjectileEngine.BehaviorContext.ROTATION)
	_direction_behavior_values[
		ProjectileEngine.DirectionModify.DIRECTION_ROTATION] =  _rotation
	return _direction_behavior_values


	# _direction_behavior_values.clear()
	# match direction_modify_method:
	# 	DirectionModifyMethod.ROTATION:
	# 		if direction_normalize:
	# 			_direction_behavior_values[
	# 				ProjectileEngine.DirectionModify.DIRECTION_ROTATION] = _direction_parse_value.normalized().angle()
	# 		else:
	# 			_direction_behavior_values[
	# 				ProjectileEngine.DirectionModify.DIRECTION_ROTATION] = _direction_parse_value.angle()
	# 	DirectionModifyMethod.ADDITION:
	# 		if direction_normalize:
	# 			_direction_behavior_values[
	# 				ProjectileEngine.DirectionModify.DIRECTION_ADDITION] = (_direction_parse_value.normalized())
	# 		else:
	# 			_direction_behavior_values[
	# 				ProjectileEngine.DirectionModify.DIRECTION_ADDITION] = _direction_parse_value
	# 	DirectionModifyMethod.OVERRIDE:
	# 		_direction_behavior_values[
	# 			ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE] = _direction_parse_value.normalized()
	# 	_:
	# 		pass
	
	# return _direction_behavior_values
