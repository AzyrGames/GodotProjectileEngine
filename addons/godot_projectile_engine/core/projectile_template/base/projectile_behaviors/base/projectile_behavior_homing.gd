extends ProjectileBehavior
class_name ProjectileBehaviorHoming

enum HomingModifyMethod{
	ADDITION,
	MULTIPLICATION,
	OVERRIDE,
}

## Processes homing behavior and returns modified direction
## Returns Array with [new_direction: Vector2, rotation: float (optional), addition: Vector2 (optional)]
func process_behavior(_value: Vector2, _context: Dictionary) -> Array:
	return [_value]
