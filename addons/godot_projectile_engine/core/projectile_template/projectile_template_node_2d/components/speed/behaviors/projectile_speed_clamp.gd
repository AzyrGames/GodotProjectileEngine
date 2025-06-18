extends ProjectileBehaviorSpeed
class_name ProjectileSpeedClamp


@export var max_value : float = 300.0
@export var min_value : float = -300.0


func process_behavior(_value: float, _context: Dictionary) -> float:
	return clampf(_value, min_value, max_value)


