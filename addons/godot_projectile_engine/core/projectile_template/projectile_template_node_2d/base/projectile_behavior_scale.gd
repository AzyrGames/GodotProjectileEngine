extends ProjectileBehavior
class_name ProjectileBehaviorScale

enum ScaleModifyMethod{
	## Add value to the current speed
	ADDTITION,
	# ADDTITION_OVER_BASE,
	## Multiple value to the current speed
	MULTIPLICATION,
	# MULTIPLICATION_OVER_BASE,
	## Override the current speed
	OVERRIDE,
}

func process_behavior(_value: Vector2, _context: Dictionary) -> Vector2:
	return _value

