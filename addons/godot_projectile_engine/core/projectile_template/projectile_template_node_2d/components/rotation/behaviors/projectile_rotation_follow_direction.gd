extends ProjectileBehaviorRotation
class_name ProjectileRotationFollowDirection

## Make rotation follow the angle of the Direction.

# @export var modify_method: RotationModifyMethod = RotationModifyMethod.OVERRIDE


var _target_direction : float

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.DIRECTION
	]

## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> float:
	if !_context.has(ProjectileEngine.BehaviorContext.DIRECTION): return _value
	_target_direction = _context.get(ProjectileEngine.BehaviorContext.DIRECTION).angle()
	
	return _target_direction
