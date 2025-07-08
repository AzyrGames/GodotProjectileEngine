extends ProjectileBehaviorSpeed
class_name ProjectileSpeedSet

@export var speed_value : float

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return []

var speed_behavior_values : Dictionary = {
}

## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	speed_behavior_values["speed_overwrite"] = speed_value
	return speed_behavior_values
