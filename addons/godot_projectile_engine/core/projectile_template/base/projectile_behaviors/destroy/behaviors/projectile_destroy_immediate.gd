extends ProjectileBehaviorDestroy
class_name ProjectileDestroyImmediate

## Immediate destroy behavior that destroys projectiles instantly when processed

## Processes immediate destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:
	return true
