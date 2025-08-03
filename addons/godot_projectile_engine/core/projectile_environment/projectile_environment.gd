@icon("uid://do6goevp2kieu")
extends Node2D
class_name ProjectileEnvironment2D

var projectile_bouncing_helper : ProjectileBouncingHelper

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
	if !ProjectileEngine.projectile_updater_2d_nodes.get(area_rid): return
	ProjectileEngine.projectile_updater_2d_nodes.get(area_rid).spawner_destroyed = true
	pass


func projectile_collided(projectile_area_rid: RID, shape_idx: int) -> void:
	if !ProjectileEngine.projectile_updater_2d_nodes.has(projectile_area_rid): return
	if !is_instance_valid(ProjectileEngine.projectile_updater_2d_nodes[projectile_area_rid]):
		return

	ProjectileEngine.projectile_updater_2d_nodes[projectile_area_rid].process_projectile_collided(shape_idx)


func get_projectile_damage(projectile_area_rid: RID) -> int:
	if !ProjectileEngine.projectile_updater_2d_nodes.has(projectile_area_rid): return 0
	if !is_instance_valid(ProjectileEngine.projectile_updater_2d_nodes[projectile_area_rid]):	return 0
	if ProjectileEngine.projectile_updater_2d_nodes.has(projectile_area_rid):
		return ProjectileEngine.projectile_updater_2d_nodes[projectile_area_rid].projectile_damage
	return 0


func request_bouncing_helper(_projectile_collision_shape: Shape2D) -> void:
	if projectile_bouncing_helper: return
	projectile_bouncing_helper = ProjectileBouncingHelper.new()
	var _collision_shape := CollisionShape2D.new()
	_collision_shape.shape = _projectile_collision_shape

	add_child(projectile_bouncing_helper, true)
	projectile_bouncing_helper.add_child(_collision_shape, true)
	pass

# func setup_projectile_bouncing_helper() -> void:
# 	projectile_bouncing_helper
# 	pass
