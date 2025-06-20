extends ProjectileBehavior
class_name ProjectileBehaviorDirection

enum DirectionModifyMethod{
	## Add value to the current direction
	ADDTITION,
	## Add value to the base direction
	# ADDTITION_OVER_BASE,
	## Override the current direction
	OVERRIDE,
}

func process_behavior(_value: Vector2, _context: Dictionary) -> Vector2:
	return _value