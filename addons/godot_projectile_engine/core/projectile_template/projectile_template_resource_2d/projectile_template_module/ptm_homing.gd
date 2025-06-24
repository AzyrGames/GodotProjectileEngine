extends ProjectileTemplateModule
class_name PTMHoming

enum HomingTargetType{
	GROUP,
}
enum HomingGroupSelection{
	FIRST,
	NEAREST,
	RANDOM,
}

@export var homing_steer_speed : float = 10.0

# @export var homing_delay_time : float
# @export var homing_delay_distance : float

# @export var homing_stop_time : float
# @export var homing_stop_distance : float

@export var homing_target_type : HomingTargetType
@export var homing_group: String


var homing_target_nodes: Array
var homing_target_node : Node

var homing_target_position : Vector2


var homing_target_direction : Vector2

var delta : float 

func _init() -> void:
	pass

func process_template(active_projectile_instances: Array[ProjectileInstance2D]) -> void:
	if active_projectile_instances.size() <= 0: return
	if homing_group == null: return
	if !ProjectileEngine.projectile_updater_2d_nodes.has(active_projectile_instances[0].area_rid) : return
	var _node : = ProjectileEngine.projectile_updater_2d_nodes[active_projectile_instances[0].area_rid]
	delta = _node.get_physics_process_delta_time()

	homing_target_nodes = _node.get_tree().get_nodes_in_group(homing_group)
	if homing_target_nodes.size() <= 0 : return
	for _group_node : Node in homing_target_nodes:
		if _group_node is Node2D:
			homing_target_node = _group_node
	if !homing_target_node: return
	homing_target_position = homing_target_node.global_position

	for _projectile_instance in active_projectile_instances:
		homing_target_direction = _projectile_instance.global_position.direction_to(homing_target_position)
		_projectile_instance.move_direction = _projectile_instance.move_direction.move_toward(homing_target_direction, homing_steer_speed * delta)
	pass
