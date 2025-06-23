extends ProjectileBehaviorDestroy
class_name ProjectileDestroyTime

## Time-based destroy behavior that destroys projectiles after a specified duration

## Time in seconds after which the projectile should be destroyed
@export var destroy_time: float = 5.0

## Custom timer for tracking time (used when use_life_time is false)
var custom_timer: float = 0.0

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	var contexts: Array[ProjectileEngine.BehaviorContext] = []
	
	contexts.append(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND)
	
	return contexts

## Processes time-based destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:
	var current_time: float = 0.0

	if _context.has(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND):
		current_time = _context[ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND]
	else:
		return false
	
	return current_time >= destroy_time

## Called when the projectile is destroyed
func on_destroy(_projectile: Node, _context: Dictionary) -> void:
	# Add any time-based destruction effects here
	pass
