@icon("uid://cd2yhrjd4vb5f")
extends PatternComposerComponent
class_name PCCSingle2D


## Pattern Composer Component Single 2D.[br]
## Set [param direction] and [param rotation] for each incoming [PatternComposerData]


enum DirectionType {
	INHERIT, ## Use the current ProjectileSpawner direction
	FIXED, ## Overwrite the direction with [param fixed_direction]
	TARGET_GROUP, ## 
	MOUSE, ## Direction from ProjectileSpawner to the mouse position
}

enum RotationProcessMode {
	PHYSICS, ## Apply rotation speed in physics_process
	TICKS ## Apply rotation speed each time pattern was processed
}

var _request_tick: bool = false

## Type of direction will be processed
@export var direction_type: DirectionType
## [enum DirectionType][code].FIXED[/code][br]
## Normalized fixed direction
@export var fixed_direction: Vector2 = Vector2.RIGHT
## Target group name
@export var target_group: String
## Group node selection method 
@export var group_selection: ProjectileEngine.TargetGroupSelection
## Direction Rotation as degrees
@export_range(-360, 360, 0.1, "radians_as_degrees","suffix:°") var direction_rotation: float = 0

## Direction Rotation Speed as degrees
@export var rotation_speed: float = 0

# @export var rotation_speed_curve : CurveTexture
## rotation process update mode
@export var rotation_process_mode: RotationProcessMode

@export_group("Random")
## Array of target group names
@export var target_groups: PackedStringArray

## Random rotation value
@export var rotation_random: Vector3
## Random rotation speed value
@export var rotation_speed_random: Vector3

var _target_nodes: Array[Node2D]
var _final_rotation: float

var _nearest_target: Node2D
var _nearest_distance: float
var _distance: float


func _ready() -> void:
	if rotation_speed_random != Vector3.ZERO:
		rotation_speed = ProjectileEngine.get_random_float_value(rotation_speed_random)


func process_pattern(
	_pattern_composer_pack: Array[PatternComposerData],
	_pattern_composer_context: PatternComposerContext
	) -> Array:
	
	_new_pattern_composer_pack = []
	for _pattern_composer_data: PatternComposerData in _pattern_composer_pack:
		_new_pattern_composer_data = _pattern_composer_data.duplicate()
		_final_rotation = _pattern_composer_data.direction_rotation
		if rotation_random != Vector3.ZERO:
			_final_rotation += deg_to_rad(ProjectileEngine.get_random_float_value(rotation_random))
		_final_rotation += direction_rotation
		_new_pattern_composer_data.direction_rotation = _final_rotation
		match direction_type:
			DirectionType.INHERIT:
				_new_pattern_composer_pack.append(_new_pattern_composer_data)
				continue

			DirectionType.FIXED:
				_new_pattern_composer_data.direction = fixed_direction
				_new_pattern_composer_pack.append(_new_pattern_composer_data)
				continue

			DirectionType.TARGET_GROUP:
				if target_group == "":
					_new_pattern_composer_pack.append(_new_pattern_composer_data)
					continue
		
				if target_groups.is_empty():
					_target_nodes = ProjectileEngine.get_valid_target_group_nodes(target_group)
				else:
					_update_target_nodes_group_choice()
				
				if _target_nodes.is_empty():
					_new_pattern_composer_pack.append(_new_pattern_composer_data)
					continue

				_new_pattern_composer_data.direction = _pattern_composer_data.position.direction_to(
					get_target_position(_pattern_composer_data)
					)
				_new_pattern_composer_pack.append(_new_pattern_composer_data)
				continue

			DirectionType.MOUSE:
				_new_pattern_composer_data.direction = _new_pattern_composer_data.position.direction_to(get_mouse_position())
				_new_pattern_composer_pack.append(_new_pattern_composer_data)
				continue

	if rotation_process_mode == RotationProcessMode.TICKS:
		_request_tick = true

	return _new_pattern_composer_pack


func update(_pattern_composer_pack: Array[PatternComposerData]) -> void:
	for _pattern_composer_data in _pattern_composer_pack:
		if !_pattern_composer_data: return
		match rotation_process_mode:
			RotationProcessMode.TICKS:
				if !_request_tick: return
				_pattern_composer_data.direction_rotation += deg_to_rad(rotation_speed)
				# print("_pattern_composer_data.direction_rotation", _pattern_composer_data.direction_rotation)

			RotationProcessMode.PHYSICS:
				_pattern_composer_data.direction_rotation += deg_to_rad(rotation_speed) * get_physics_process_delta_time()

	_request_tick = false
	pass


# Search and return the first Node2D in a Group, return null if not founded
func get_first_node2d_group(_group_name: String) -> Node2D:
	if _group_name == null:
		return
	return


## Get global mouse position using projectile_environment
func get_mouse_position() -> Vector2:
	if ProjectileEngine.projectile_environment:
		return ProjectileEngine.projectile_environment.get_global_mouse_position()
	else:
		return Vector2.ZERO


func _update_target_nodes_group_choice() -> void:
	# Todo: Cache Group choice to update when changed
	_target_nodes.clear()
	for _target_group in target_groups:
		for _node: Node in get_tree().get_nodes_in_group(_target_group):
			if !_node is Node2D or !is_instance_valid(_node): continue
			if _target_nodes.has(_node): continue
			_target_nodes.append(_node)


func get_target_position(_pattern_composer_data: PatternComposerData) -> Vector2:
	match group_selection:
		ProjectileEngine.TargetGroupSelection.FIRST:
			return _target_nodes[0].global_position

		ProjectileEngine.TargetGroupSelection.NEAREST:
			_nearest_target = _target_nodes[0]
			_nearest_distance = _pattern_composer_data.position.distance_to(_nearest_target.global_position)
			for _target_node in _target_nodes:
				_distance = _pattern_composer_data.position.distance_to(_target_node.global_position)
				if _distance < _nearest_distance:
					_nearest_distance = _distance
					_nearest_target = _target_node
			return _nearest_target.global_position

		ProjectileEngine.TargetGroupSelection.RANDOM:
			return _target_nodes[randi() % _target_nodes.size()].global_position

	return _pattern_composer_data.position
