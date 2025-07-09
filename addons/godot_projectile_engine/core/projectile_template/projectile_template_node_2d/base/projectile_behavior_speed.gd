extends ProjectileBehavior
class_name ProjectileBehaviorSpeed

enum SpeedModifyMethod{
	## Add value to the current speed
	ADDITION,
	## Add value to the base speed
	ADDITION_OVER_BASE,
	## Multiply value to the current speed
	MULTIPLICATION,
	## Multiply value to the base speed
	MULTIPLICATION_OVER_BASE,
	## Override the current speed
	OVERRIDE,
}

var _speed_behavior_values : Dictionary = {}

func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	return {"speed_overwrite" : _value}

