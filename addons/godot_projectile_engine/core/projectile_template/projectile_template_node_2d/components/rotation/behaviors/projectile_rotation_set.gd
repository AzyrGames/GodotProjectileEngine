extends ProjectileBehaviorRotation
class_name ProjectileRotationSet

@export_custom(PROPERTY_HINT_NONE, "suffix:°") var rotation_value : float

func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	return {"rotation_overwrite": rotation_value}
