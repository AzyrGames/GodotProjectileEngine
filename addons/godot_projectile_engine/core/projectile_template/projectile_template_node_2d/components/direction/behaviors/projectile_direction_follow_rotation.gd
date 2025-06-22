extends ProjectileBehaviorDirection
class_name ProjectileDirectionFollowRotation

## Make direction follow 


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.ROTATION,
	]


var _rotation: float


func process_behavior(_value: Vector2, _context: Dictionary) -> Array:
	if !_context.has(ProjectileEngine.BehaviorContext.ROTATION): return [_value]
	_rotation = _context.get(ProjectileEngine.BehaviorContext.ROTATION)

	return [_value, _rotation - _value.angle()]
