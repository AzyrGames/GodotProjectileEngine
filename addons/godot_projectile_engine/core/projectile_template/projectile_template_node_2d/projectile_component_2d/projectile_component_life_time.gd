extends ProjectileComponent
class_name ProjectileComponentLifeTime

## Projectile Life Time update every process (Rendered) frame time

# enum UpdateMode {
# 	IDLE, ## Update the timing every process (rendered) frame
# 	PHYSICS, ## Update the timing every physics process frame
# }

# @export var update_mode : UpdateMode = UpdateMode.PHYSICS

var current_life_time : float


func _process(delta: float) -> void:
	if !active: return
	current_life_time += delta
	pass

# func _physics_process(delta: float) -> void:
# 	if !active: return
# 	if update_mode == UpdateMode.PHYSICS:
# 		current_life_time += delta
# 	pass

func get_life_time() -> float:
	return current_life_time
	pass