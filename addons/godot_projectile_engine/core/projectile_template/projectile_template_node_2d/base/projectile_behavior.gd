extends Resource
class_name ProjectileBehavior

enum SampleMethod {
	# LIFE_TIME_TICK,
	LIFE_TIME_SECOND,
	# LIFE_DISTANCE,
}

@export var active : bool = true

func behavior_context_request() -> Array[ProjectileEngine.BehviorContext]:
	return []


func process_behavior(_value, _context):
	pass
