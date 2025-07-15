extends ProjectileBehaviorSpeed
class_name ProjectileSpeedSet

@export var speed_value : float

func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	return {"speed_overwrite": speed_value}
