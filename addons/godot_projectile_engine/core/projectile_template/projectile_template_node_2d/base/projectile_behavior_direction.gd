extends ProjectileBehavior
class_name ProjectileBehaviorDirection

enum DirectionModifyMethod{
	## Add value to the current direction
	ROTATION,
	ADDITION,
	OVERRIDE,
}

var _direction_behavior_values : Dictionary

func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	return {}