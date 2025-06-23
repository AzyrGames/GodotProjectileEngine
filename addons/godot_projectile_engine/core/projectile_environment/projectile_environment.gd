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


func request_bouncing_helper(asdfasdfas: CollisionShape2D) -> void:
	if projectile_bouncing_helper: return
	projectile_bouncing_helper = ProjectileBouncingHelper.new()
	var _collision_shape := CollisionShape2D.new()
	var _shape : = CircleShape2D.new()
	_shape.radius = 6.0
	_collision_shape.shape = _shape

	# var 
	# projectile_bouncing_helper.add_child(_collision_shape.duplicate())
	add_child(projectile_bouncing_helper)
	projectile_bouncing_helper.add_child(_collision_shape)
	pass

# func setup_projectile_bouncing_helper() -> void:
# 	projectile_bouncing_helper
# 	pass
