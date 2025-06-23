extends ProjectileBehaviorDestroy
class_name ProjectileDestroyImmediate

## Immediate destroy behavior that destroys projectiles instantly when processed

## Whether to destroy on the first frame or wait for a trigger
@export var destroy_on_first_process: bool = true

var _first_process: bool = true

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return []

## Processes immediate destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:
	if not destroy_on_first_process and _first_process:
		_first_process = false
		return false

	return true
