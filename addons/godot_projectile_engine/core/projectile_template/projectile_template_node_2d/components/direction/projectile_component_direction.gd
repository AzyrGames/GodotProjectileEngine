extends ProjectileComponent
class_name ProjectileComponentDirection


func get_component_name() -> StringName:
	return "projectile_component_direction"

@export var direction: Vector2 = Vector2.RIGHT

@export var component_behaviors : Array[ProjectileBehaviorDirection] = []


var _component_behavior_convert : Array[ProjectileBehavior]


func _physics_process(delta: float) -> void:
	if !active : return
	if !component_behaviors: return
	_component_behavior_convert.assign(component_behaviors)
	update_behavior_context(_component_behavior_convert)
	process_projectile_behavior(_component_behavior_convert, component_context)
	pass


func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	for _behavior in _behaviors:
		if !_behavior: continue
		_behavior.process_behavior(direction, _context)
		pass
	pass
