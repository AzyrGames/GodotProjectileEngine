extends ProjectileBehaviorDestroy
class_name ProjectileDestroyLifeTime

## Time-based destroy behavior that destroys projectiles after a specified duration

## Time in seconds after which the projectile should be destroyed
@export var destroy_time: float = 5.0

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND
	]

func process_behavior(_value, _context: Dictionary) -> bool:
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND):
		return false

	return _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND) >= destroy_time