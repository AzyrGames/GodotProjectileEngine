extends ProjectileBehavior
class_name ProjectileBehaviorSpeed

enum SpeedModifyMethod{
	## Add value to the current speed
	ADDTITION,
	# ADDTITION_OVER_BASE,
	## Multiple value to the current speed
	MULTIPLICATION,
	# MULTIPLICATION_OVER_BASE,
	## Override the current speed
	OVERRIDE,
}

func process_behavior(_value: float, _context: Dictionary) -> float:
	return _value

