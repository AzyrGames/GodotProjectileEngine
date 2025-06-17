# @tool
extends ProjectileComponent
class_name ProjectileComponentSpeed


func get_component_name() -> StringName:
	return "projectile_component_speed"

# Public read-only access, unless allow_external_modification
@export var speed: float = 100.0:
	set(_value):
		_initial_speed = _value
		if allow_external_modification:
			_intenal_speed = _value
		notify_property_list_changed()
	get:
		return _intenal_speed

@export var component_behaviors : Array[ProjectileBehaviorSpeed] = []

var _intenal_speed : float
@export_storage var _initial_speed : float = 100.0


# --- SAFE MODIFICATION API ---
func add_value(_value: float) -> void:
	if allow_external_modification:
		_intenal_speed += _value
	pass

func multiple_value(_value: float) -> void:
	if allow_external_modification:
		_intenal_speed *= _value
	pass


func override_value(_value: float) -> void:
	if allow_external_modification:
		_intenal_speed = _value
	pass


func force_apply_value(_value: float) -> void:
	_intenal_speed = _value
	pass


func _ready() -> void:
	_intenal_speed = _initial_speed
	pass


var _component_behavior_convert : Array[ProjectileBehavior]


func _physics_process(delta: float) -> void:
	if !active : return
	if Engine.is_editor_hint():
		pass
	else:
		if !component_behaviors: return
		_component_behavior_convert.assign(component_behaviors)
		process_projectile_behavior(_component_behavior_convert, component_context)
	pass


func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	for _behavior in _behaviors:
		if !_behavior: continue
		_behavior.process_behavior(_context)
		pass
	pass
