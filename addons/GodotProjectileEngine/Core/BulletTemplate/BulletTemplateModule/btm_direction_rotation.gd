extends BulletTemplateModule
class_name BTMDirectionRotation

enum RotationType {
	PHYSICS, ## rotation speed change in physics_process
	TICKS ## rotation speed each time pattern was processed
}

@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_speed : float = 0.0
@export var update_type : RotationType

var delta : float

func process_template(active_bullet_instances: Array[BulletInstance2D]) -> void:
	if active_bullet_instances.size() <= 0: return
	if !BulletHell.bullet_updater_2d_nodes.has(active_bullet_instances[0].area_rid) : return
	var _node : = BulletHell.bullet_updater_2d_nodes[active_bullet_instances[0].area_rid]
	delta = _node.get_physics_process_delta_time()
	match update_type:
		RotationType.PHYSICS:
			for _bullet_instance in active_bullet_instances:
				_bullet_instance.move_direction = _bullet_instance.move_direction.rotated(rotation_speed * delta)
		RotationType.TICKS:
			for _bullet_instance in active_bullet_instances:
				_bullet_instance.move_direction = _bullet_instance.move_direction.rotated(rotation_speed)

	pass
