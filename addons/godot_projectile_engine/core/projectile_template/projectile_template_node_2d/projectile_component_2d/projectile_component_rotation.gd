extends ProjectileComponent
class_name ProjectileComponentRotation


func get_component_name() -> StringName:
	return "projectile_component_rotation"

@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation : float = 0
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_speed : float = 0

