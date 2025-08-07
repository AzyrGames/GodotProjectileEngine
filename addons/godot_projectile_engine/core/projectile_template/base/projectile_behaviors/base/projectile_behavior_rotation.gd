extends ProjectileBehavior
class_name ProjectileBehaviorRotation

enum RotationModifyMethod {
	## Add value to the current rotation
	ADDITION,
	## Add value to the base rotation
	ADDITION_OVER_TIME,
	# ## Multiply value to the current rotation
	# MULTIPLICATION,
	# ## Multiply value to the base rotation
	# MULTIPLICATION_OVER_BASE,
	## Override the current rotation
	OVERRIDE,
}

enum RotationProcessMode {
	PHYSICS,
	TICKS,
}

func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	return behavior_values
