extends ProjectileComponent
class_name ProjectileComponentLifeTime

## Projectile Life Time update every process (Rendered) frame time

var life_time_second : float

func get_component_name() -> StringName:
	return "projectile_component_life_time"

func _process(delta: float) -> void:
	if !active: return
	update_life_time()
	pass

func update_life_time() -> void:
	life_time_second += get_process_delta_time()
	pass

func get_life_time() -> float:
	return life_time_second
	pass
