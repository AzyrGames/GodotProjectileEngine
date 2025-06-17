# @tool
extends ProjectileComponent
class_name ProjectileComponentDirection


func get_component_name() -> StringName:
	return "projectile_component_direction"

# Public read-only access, unless allow_external_modification
@export var direction: float = 100.0:
	set(value):
		_initial_direction = value
		if allow_external_modification:
			_intenal_direction = value
		notify_property_list_changed()
	get:
		return _intenal_direction

@export var component_behaviors : Array[ProjectileBehaviorDirection] = []

var _intenal_direction : float
@export_storage var _initial_direction : float


# --- SAFE MODIFICATION API ---
func add_value(_value: float) -> void:
	if allow_external_modification:
		_intenal_direction += _value
	pass

func multiple_value(_value: float) -> void:
	if allow_external_modification:
		_intenal_direction *= _value
	pass


func override_value(_value: float) -> void:
	if allow_external_modification:
		_intenal_direction = _value
	pass


func _ready() -> void:
	_intenal_direction = _initial_direction
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
