extends ProjectileBehaviorSpeed
class_name ProjectileSpeedSet

@export var speed_value : float

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return []

func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	return {"speed_overwrite": speed_value}
