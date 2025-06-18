extends Resource
class_name ProjectileBehavior

@export var active : bool = true

func behavior_context_request() -> Array[ProjectileEngine.BehviorContext]:
	return []


func process_behavior(_value, _context):
	pass
