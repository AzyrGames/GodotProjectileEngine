extends ProjectileComponent
class_name ProjectileComponentRotation

## Animate the rotation of the Projectle, not effecting the direction. 

func get_component_name() -> StringName:
	return "projectile_component_rotation"

@export_range(0, 360, 0.1, "radians_as_degrees") var rotation : float = 0.0

@export var component_behaviors : Array[ProjectileBehaviorRotation] = []

var base_rotation: float

var _component_behavior_convert : Array[ProjectileBehavior]
var _rotation_delta : float

func _ready() -> void:
	base_rotation = rotation

func _physics_process(delta: float) -> void:
	if !active:
		return

	# if !component_behaviors:
	# 	return

	# Convert behaviors to base type for processing
	# _component_behavior_convert.assign(component_behaviors)

	# update_behavior_context(_component_behavior_convert)
	process_projectile_behavior(_component_behavior_convert, owner.behavior_context)

func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue
		var _new_rotation  = _behavior.process_behavior(rotation, _context)
		_rotation_delta = _new_rotation - base_rotation
		rotation = _new_rotation


func get_rotation() -> float:
	return rotation
	pass
