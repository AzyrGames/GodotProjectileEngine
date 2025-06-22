extends ProjectileBehavior
class_name ProjectileBehaviorDirection

enum DirectionModifyMethod{
	## Add value to the current direction
	ROTATION,
	ADDITION,
	OVERRIDE,
}

func process_behavior(_value: Vector2, _context: Dictionary) -> Array:
	return [_value, 0.0]