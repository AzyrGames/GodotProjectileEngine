extends ProjectileBehaviorScale
class_name ProjectileScaleSet

@export var scale_value : Vector2 = Vector2.ONE

func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	behavior_values.clear()
	behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = scale_value

	return behavior_values