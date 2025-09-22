extends ProjectileBehaviorRotation
class_name ProjectileRotationFollowDirection

## Make rotation follow the angle of the Direction.

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.DIRECTION,
		ProjectileEngine.BehaviorContext.DIRECTION_ROTATION,
	]


func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	if !_context.has(ProjectileEngine.BehaviorContext.DIRECTION): 
		return {}
	if !_context.has(ProjectileEngine.BehaviorContext.DIRECTION_ROTATION): 
		return {}
	var _direction := _context.get(ProjectileEngine.BehaviorContext.DIRECTION)
	var _direction_rotation := _context.get(ProjectileEngine.BehaviorContext.DIRECTION_ROTATION)
	var _rotation_final : float = _direction.rotated(_direction_rotation).angle()
	return {ProjectileEngine.RotationModify.ROTATION_OVERWRITE : _rotation_final}
