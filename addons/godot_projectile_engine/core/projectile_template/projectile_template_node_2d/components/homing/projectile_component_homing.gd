extends ProjectileComponent
class_name ProjectileComponentHoming


func get_component_name() -> StringName:
	return "projectile_component_homing"

func _physics_process(delta: float) -> void:
	# print("Homing Owner: ", owner)
	pass