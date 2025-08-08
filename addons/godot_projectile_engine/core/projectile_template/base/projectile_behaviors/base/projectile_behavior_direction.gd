extends ProjectileBehavior
class_name ProjectileBehaviorDirection

enum DirectionModifyMethod{
	ROTATION,
	ADDITION,
	OVERRIDE,
}

@export var direction_normalize : bool = true

var _direction_behavior_values : Dictionary

func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	return _direction_behavior_values