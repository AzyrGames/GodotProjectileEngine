extends ProjectileTemplateModule
class_name PTMDirectionRotation

enum RotationType {
	PHYSICS, ## rotation speed change in physics_process
	TICKS ## rotation speed each time pattern was processed
}

@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_speed : float = 0.0
@export var update_type : RotationType

var delta : float

func process_template(active_projectile_instances: Array[ProjectileInstance2D]) -> void:
	if active_projectile_instances.size() <= 0: return
	if !ProjectileEngine.projectile_updater_2d_nodes.has(active_projectile_instances[0].area_rid) : return
	var _node : = ProjectileEngine.projectile_updater_2d_nodes[active_projectile_instances[0].area_rid]
	delta = _node.get_physics_process_delta_time()
	match update_type:
		RotationType.PHYSICS:
			for _projectile_instance in active_projectile_instances:
				_projectile_instance.move_direction = _projectile_instance.move_direction.rotated(rotation_speed * delta)
		RotationType.TICKS:
			for _projectile_instance in active_projectile_instances:
				_projectile_instance.move_direction = _projectile_instance.move_direction.rotated(rotation_speed)

	pass
