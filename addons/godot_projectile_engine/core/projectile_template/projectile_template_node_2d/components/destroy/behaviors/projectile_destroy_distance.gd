extends ProjectileBehaviorDestroy
class_name ProjectileDestroyDistance

## Distance-based destroy behavior that destroys projectiles after traveling a specified distance

## Distance in pixels after which the projectile should be destroyed
@export var destroy_distance: float = 1000.0


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	var contexts: Array[ProjectileEngine.BehaviorContext] = []
	
	contexts.append(ProjectileEngine.BehaviorContext.LIFE_DISTANCE)
	return contexts

## Processes distance-based destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:
	var current_distance: float = 0.0
	
	if _context.has(ProjectileEngine.BehaviorContext.LIFE_DISTANCE):
		current_distance = _context[ProjectileEngine.BehaviorContext.LIFE_DISTANCE]
	else:
		return false
	
	return current_distance >= destroy_distance
