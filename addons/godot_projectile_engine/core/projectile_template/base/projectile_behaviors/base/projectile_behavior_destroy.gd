extends ProjectileBehavior
class_name ProjectileBehaviorDestroy

## Base class for all projectile destroy behaviors in the projectile engine.

## Processes the destroy behavior and returns whether projectile should be destroyed
## Returns bool: true if projectile should be destroyed, false otherwise
func process_behavior(_value, _context: Dictionary) -> bool:
	return false
