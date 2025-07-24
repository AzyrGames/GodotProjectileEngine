## Projectile Pattern Component Base

extends PatternComposerComponent
class_name PCCSingle2D

enum DirectionType {
	INHERIT, ## Use the current ProjectileSpawner direction
	FIXED, ## Overwrite the direction with `fixed_direction`
	TARGET, ## Direction from ProjectileSpawner to the target Position
	MOUSE, ## Direction from ProjectileSpawner to the mouse position
}

enum RotationProcessMode {
	PHYSICS, ## Apply rotation speed in physics_process
	TICKS ## Apply rotation speed each time pattern was processed
}

## Type of direction 
@export var direction_type : DirectionType

## Normalized fixed direction for Fixed DirectionType
@export var fixed_direction : Vector2 = Vector2.RIGHT
## Normalized target group name for TARGET DirectionType
@export var group_name : String

## Direction Rotation as degrees
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation : float = 0
## Direction Rotation Speed as degrees
@export var rotation_speed : float = 0

@export var rotation_process_mode : RotationProcessMode

@export_range(0, 360) var random_angle : float = 0.0

var _request_tick : bool = false
var _rng : RandomNumberGenerator
var _target_node : Node2D


func _ready() -> void:
	pass


func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	for _pattern_composer_data : PatternComposerData in pattern_composer_pack:
		var _rng_angle : float
		var _final_rotation : float = _pattern_composer_data.rotation
		if random_angle != 0:
			_rng = RandomNumberGenerator.new()
			_rng_angle = _rng.randf_range(-random_angle / 2.0, random_angle / 2.0)
			_final_rotation += deg_to_rad(_rng_angle)
		match direction_type:
			DirectionType.INHERIT:
				_pattern_composer_data.direction = _pattern_composer_data.base_direction.rotated(_final_rotation).normalized()
				pass
			DirectionType.FIXED:
				_pattern_composer_data.direction = fixed_direction.rotated(_final_rotation).normalized()
				pass
			DirectionType.TARGET:
				var _target_node := get_first_node2d_group(group_name)
				if _target_node:
					_pattern_composer_data.direction = _pattern_composer_data.position.direction_to(_target_node.position)
				pass
			DirectionType.MOUSE:
				var _mouse_position := get_mouse_position()
				if _mouse_position:
					_pattern_composer_data.direction = _pattern_composer_data.position.direction_to(_mouse_position)
				pass
	if rotation_process_mode == RotationProcessMode.TICKS:
		_request_tick = true
	return pattern_composer_pack


func update(pattern_composer_pack : Array[PatternComposerData]) -> void:
	for _pattern_composer_data in pattern_composer_pack:
		if !_pattern_composer_data: return
		match rotation_process_mode:
			RotationProcessMode.TICKS:
				if !_request_tick: return
				_pattern_composer_data.rotation += deg_to_rad(rotation_speed)
				
			RotationProcessMode.PHYSICS:
				_pattern_composer_data.rotation += deg_to_rad(rotation_speed) * get_physics_process_delta_time()
	_request_tick = false
	pass


# Search and return the first Node2D in a Group, return null if not founded
func get_first_node2d_group(_group_name : String) -> Node2D:
	if _group_name == null:
		return
	for _node: Node in get_tree().get_nodes_in_group(_group_name):
		if _node is Node2D:
			return _node
	return


## Get global mouse position using projectile_environment
func get_mouse_position() -> Vector2:
	if ProjectileEngine.projectile_environment:
		return ProjectileEngine.projectile_environment.get_global_mouse_position()
	else:
		return Vector2.ZERO
	pass