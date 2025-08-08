extends ProjectileBehaviorSpeed
class_name ProjectileSpeedSet

@export var speed_value : float

func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	return {ProjectileEngine.SpeedModify.SPEED_OVERWRITE: speed_value}
