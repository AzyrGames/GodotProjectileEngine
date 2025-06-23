extends ProjectileBehaviorBouncing
class_name BounceRicochet


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.DIRECTION_COMPONENT,
	]

func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return []


func process_behavior(_value, _context: Dictionary) -> bool:
	var _projectile_component_direction = _context.get(ProjectileEngine.BehaviorContext.DIRECTION_COMPONENT)
	if !_projectile_component_direction or _projectile_component_direction is not ProjectileComponentDirection:
		return false
	var _collision_normal : Vector2 = _context.get("collision_normal")
	if !_context.has("collision_normal"):
		return false

	_projectile_component_direction.direction = _projectile_component_direction.get_direction().reflect(_context.get("collision_normal")) * -1.0

	return true
	

