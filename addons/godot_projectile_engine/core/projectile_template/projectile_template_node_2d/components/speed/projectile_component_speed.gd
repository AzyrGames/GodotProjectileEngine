# @tool
extends ProjectileComponent
class_name ProjectileComponentSpeed


func get_component_name() -> StringName:
	return "projectile_component_speed"

@export var speed: float = 100.0

@export var component_behaviors : Array[ProjectileBehaviorSpeed] = []

var base_speed : float = 100.0

var _component_behavior_convert : Array[ProjectileBehavior]

func _ready() -> void:
	base_speed = speed

func _physics_process(delta: float) -> void:
	if !active : return
	if Engine.is_editor_hint():
		pass
	else:
		if !component_behaviors: return
		## Convert from ProjectileComponentSpeed to ProjectileBehavior
		_component_behavior_convert.assign(component_behaviors) 
		update_behavior_context(_component_behavior_convert)

		

		# _component_behavior_convert.

		process_projectile_behavior(_component_behavior_convert, component_context)
	pass

func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	for _behavior in _behaviors:
		if !_behavior: continue
		if !_behavior.active: continue
		speed = _behavior.process_behavior(speed, _context)
		pass
	pass
