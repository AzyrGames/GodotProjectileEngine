## Projectile Pattern Component Base

extends PatternComposerComponent
class_name PCCSingle2D

enum DirectionType {
	FIXED,
	GROUP_NAME,
	MOUSE,
}

enum RotationType {
	PHYSICS, ## rotation speed change in physics_process
	TICKS ## rotation speed each time pattern was processed
}

@export var direction_type : DirectionType

@export var direction : Vector2 = Vector2.RIGHT
## Rotate direction by rotation degree
@export var group_name : String


@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation : float = 0
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_speed : float = 0

@export var rotation_process_type : RotationType

@export_range(0, 360) var random_angle : float = 0.0

var pattern_composer_context : PatternComposerContext
var _rng : RandomNumberGenerator
var _target_node : Node2D


func _ready() -> void:
	_rng = RandomNumberGenerator.new()

	pass


func _physics_process(delta: float) -> void:
	if rotation_process_type == RotationType.PHYSICS and pattern_composer_context:
		pattern_composer_context.rotation += rotation_speed * delta

func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	pattern_composer_context = _pattern_composer_context
	for _pattern_composer_data : PatternComposerData in pattern_composer_pack:
		match direction_type:
			DirectionType.FIXED:
				_pattern_composer_data.direction = direction.normalized()
				pass
			DirectionType.GROUP_NAME:
				_target_node = get_first_node2d_group(group_name)
				if _target_node:
					_pattern_composer_data.direction = _pattern_composer_data.position.direction_to(_target_node.global_position)
			DirectionType.MOUSE:
				_pattern_composer_data.direction = _pattern_composer_data.position.direction_to(owner.get_global_mouse_position())
				
		var _rng_angle : float
		if random_angle != 0:
			_rng_angle = _rng.randf_range(-random_angle / 2.0, random_angle / 2.0)
		var _final_rotation : float = _pattern_composer_context.rotation + deg_to_rad(_rng_angle)
		_pattern_composer_data.rotation = _final_rotation
		_pattern_composer_data.direction = _pattern_composer_data.direction.rotated(_final_rotation).normalized()


	if rotation_process_type == RotationType.TICKS:
		_pattern_composer_context.rotation  += rotation_speed

	return pattern_composer_pack

## Search and return the first Node2D in a Group, return null if not founded
func get_first_node2d_group(_group_name : String) -> Node2D:
	if group_name == null:
		return
	for _node: Node in get_tree().get_nodes_in_group(group_name):
		if _node is Node2D:
			return _node
	return
