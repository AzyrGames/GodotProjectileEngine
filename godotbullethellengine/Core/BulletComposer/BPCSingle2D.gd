## Bullet Pattern Component Base

extends BPCBase
class_name BPCSingle2D



@export_group("Direction")

enum DirectionType {
	FIXED,
	TARGET,
	RANDOM,
}

# @export var direction_type : DirectionType

# @export var target : Node2D

@export var direction : Vector2 = Vector2.RIGHT
## Rotate direction by rotation degree

@export_range(0, 360) var random_angle : float = 0.0



@export_group("Rotation")

@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation : float = 0
@export var rotation_speed : float = 0


enum RotationType {
	PHYSICS, ## rotation speed change in physics_process
	PATTERN ## rotation speed each time pattern was processed
}

@export var rotation_process_type : RotationType

var composer_var_array : Array[Dictionary]

func _ready() -> void:
	# target = Global.player
	pass

func _physics_process(delta: float) -> void:
	if rotation_process_type == RotationType.PHYSICS:
		for _composer_var in composer_var_array:
			var _rotation : Variant = _composer_var.get_or_add("rotation", rotation)
			_rotation += deg_to_rad(rotation_speed) * delta
			_composer_var.set("rotation", _rotation)
			pass


func process_pattern(pattern_packs: Array, _composer_var : Dictionary) -> Array:
	if !composer_var_array.has(_composer_var):
		composer_var_array.append(_composer_var)
		pass
	var _rand := RandomNumberGenerator.new()
	for instance : Dictionary in pattern_packs:
		# match direction_type:
		# 	DirectionType.FIXED:
		# 		instance.direction = direction.normalized()
		# 		pass
		# 	DirectionType.TARGET:
		# 		if target:
		# 			instance.direction = instance.position.direction_to(target.global_position)
		# 		pass
		instance.direction = direction.normalized()
		var _rand_angle : float = _rand.randf_range(-random_angle / 2.0, random_angle / 2.0)



		instance.direction = instance.direction.rotated(_composer_var.get_or_add("rotation", rotation) + deg_to_rad(_rand_angle)).normalized()

	if rotation_process_type == RotationType.PATTERN:
		var _rotation : Variant = _composer_var.get_or_add("rotation", rotation)
		_rotation += deg_to_rad(rotation_speed)
		_composer_var.set("rotation", _rotation)

	return pattern_packs
