## Bullet Pattern Component Base

extends BPCBase
class_name BPCSingle2D



@export_group("Direction")

enum DirectionType {
	FIXED,
	TARGET,
	RANDOM,
}

@export var direction_type : DirectionType

@export var target : Node2D

@export var direction : Vector2 = Vector2.RIGHT
## Rotate direction by rotation degree

@export_range(0, 360) var random_angle : float = 0.0



@export_group("Rotation")

@export var rotation : float = 0
@export var rotation_speed : float = 0


enum RotationType {
	PHYSICS, ## rotation speed change in physics_process
	PATTERN ## rotation speed each time pattern was processed
}

@export var rotation_process_type : RotationType


func _physics_process(delta: float) -> void:
	if rotation_process_type == RotationType.PHYSICS:
		rotation += rotation_speed * delta

func process_pattern(pattern_packs: Array) -> Array:
	for instance : Dictionary in pattern_packs:
		match direction_type:
			DirectionType.FIXED:
				instance.direction = direction.normalized()
				pass
			DirectionType.TARGET:
				if target:
					instance.direction = instance.position.direction_to(target.global_position)
				pass

		var _rand_angle : float = randf_range(-random_angle / 2.0, random_angle / 2.0)

		instance.direction = instance.direction.rotated(deg_to_rad(rotation + _rand_angle))

	if rotation_process_type == RotationType.PATTERN:
		rotation += rotation_speed

	return pattern_packs
