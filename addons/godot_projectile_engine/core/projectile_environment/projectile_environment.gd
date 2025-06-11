extends Node2D
class_name ProjectileEnvironment2D


func _enter_tree() -> void:
	if ProjectileEngine.projectile_environment: return 
	ProjectileEngine.projectile_environment = self
	pass
func _exit_tree() -> void:
	ProjectileEngine.projectile_environment = null
	pass

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	pass


func spawner_destroyed(area_rid: RID) -> void:
	if !ProjectileEngine.bullet_updater_2d_nodes.get(area_rid): return
	ProjectileEngine.bullet_updater_2d_nodes.get(area_rid).spawner_destroyed = true
	pass


func bullet_collided(bullet_area_rid: RID, shape_idx: int) -> void:
	if !ProjectileEngine.bullet_updater_2d_nodes.has(bullet_area_rid): return
	if !is_instance_valid(ProjectileEngine.bullet_updater_2d_nodes[bullet_area_rid]):
		return

	ProjectileEngine.bullet_updater_2d_nodes[bullet_area_rid].process_bullet_collided(shape_idx)


func get_bullet_damage(bullet_area_rid: RID) -> int:
	if !ProjectileEngine.bullet_updater_2d_nodes.has(bullet_area_rid): return 0
	if !is_instance_valid(ProjectileEngine.bullet_updater_2d_nodes[bullet_area_rid]):	return 0
	if ProjectileEngine.bullet_updater_2d_nodes.has(bullet_area_rid):
		return ProjectileEngine.bullet_updater_2d_nodes[bullet_area_rid].bullet_damage
	return 0
