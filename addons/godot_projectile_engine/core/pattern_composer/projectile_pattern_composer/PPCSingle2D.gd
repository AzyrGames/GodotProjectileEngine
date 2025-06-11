## Bullet Pattern Component Base

extends ProjectilePatternComponent
class_name PPCSingle2D



@export_group("Direction")

enum DirectionType {
	FIXED,
	GROUP_NAME,
	MOUSE,
}

@export var direction_type : DirectionType

@export var direction : Vector2 = Vector2.RIGHT
## Rotate direction by rotation degree
@export var group_name : String

@export_range(0, 360) var random_angle : float = 0.0

@export_group("Rotation")

@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation : float = 0
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_speed : float = 0


enum RotationType {
	PHYSICS, ## rotation speed change in physics_process
	TICKS ## rotation speed each time pattern was processed
}

@export var rotation_process_type : RotationType

var composer_var_array : Array[Dictionary]

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if rotation_process_type == RotationType.PHYSICS:
		for _composer_var in composer_var_array:
			_composer_var.set("rotation", _composer_var.get_or_add("rotation", rotation) + rotation_speed * delta)
			pass


func process_pattern(pattern_packs: Array, _composer_var : Dictionary) -> Array:
	if !composer_var_array.has(_composer_var):
		composer_var_array.append(_composer_var)
		pass
	var _rand := RandomNumberGenerator.new()
	var _target_node : Node2D
	for instance : Dictionary in pattern_packs:
		match direction_type:
			DirectionType.FIXED:
				instance.direction = direction.normalized()
				pass
			DirectionType.GROUP_NAME:
				_target_node = get_first_node2d_group(group_name)
				if _target_node:
					instance.direction = instance.position.direction_to(_target_node.global_position)
			DirectionType.MOUSE:
				instance.direction = instance.position.direction_to(owner.get_global_mouse_position())
				
		var _rand_angle : float
		if random_angle != 0:
			_rand_angle = _rand.randf_range(-random_angle / 2.0, random_angle / 2.0)

		instance.direction = instance.direction.rotated(_composer_var.get_or_add("rotation", rotation) + deg_to_rad(_rand_angle)).normalized()

	if rotation_process_type == RotationType.TICKS:
		_composer_var.set("rotation", _composer_var.get_or_add("rotation", rotation) + rotation_speed)

	return pattern_packs

## Search and return the first Node2D in a Group, return null if not founded
func get_first_node2d_group(_group_name : String) -> Node2D:
	if group_name == null:
		return
	for _node: Node in get_tree().get_nodes_in_group(group_name):
		if _node is Node2D:
			return _node
	return
