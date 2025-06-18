extends ProjectileBehavior
class_name ProjectileBehaviorSpeed

enum SpeedModifyMethod{
	ADDTITION,
	# ADDTITION_OVER_BASE,
	MULTIPLIER,
	# MULTIPLIER_OVER_BASE,
	OVERRIDE,
}

func process_behavior(_value: float, _context: Dictionary) -> float:
	return _value

