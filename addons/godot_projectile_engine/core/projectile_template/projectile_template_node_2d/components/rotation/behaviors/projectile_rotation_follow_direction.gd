extends ProjectileBehaviorRotation
class_name ProjectileRotationFollowDirection

## Make rotation follow the angle of the Direction.

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.DIRECTION
	]


func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	if !_context.has(ProjectileEngine.BehaviorContext.DIRECTION): 
		return {}

	return {"rotation_overwrite" : _context.get(ProjectileEngine.BehaviorContext.DIRECTION).angle()}
