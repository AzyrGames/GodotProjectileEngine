extends ProjectileBehaviorDestroy
class_name ProjectileDestroyLifeDistance

## Distance-based destroy behavior that destroys projectiles after traveling a specified distance

## Distance in pixels after which the projectile should be destroyed
@export var destroy_distance: float = 1000.0

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_DISTANCE
	]

## Processes distance-based destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:
	var current_distance: float = 0.0
	
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_DISTANCE):
		return false

	return _context.get(ProjectileEngine.BehaviorContext.LIFE_DISTANCE) >= destroy_distance
