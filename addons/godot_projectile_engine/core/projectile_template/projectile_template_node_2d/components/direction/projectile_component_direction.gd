extends ProjectileComponent
class_name ProjectileComponentDirection

func get_component_name() -> StringName:
	return "projectile_component_direction"

@export var direction : Vector2 = Vector2.RIGHT
