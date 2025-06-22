extends ProjectileBehavior
class_name ProjectileBehaviorRotation

enum RotationModifyMethod{
	ADDITION,
	# MULTIPLICATION,
	OVERRIDE,
}

enum RotationProcessMode{
	PHYSICS,
	TICKS,
}

func process_behavior(_value: float, _context: Dictionary) -> float:
	return _value


# func apply_modified_value() -> 
