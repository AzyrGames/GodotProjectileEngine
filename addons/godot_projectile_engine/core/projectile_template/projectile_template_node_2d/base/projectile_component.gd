extends Node
class_name ProjectileComponent


## component_registered is emited when component is succesfully registered
signal component_registered(_owner: Node, _component: ProjectileComponent)

## component_deregistered is emited when component is succesfully deregistered
signal component_deregistered(_owner: Node, _component: ProjectileComponent)

@export var active : bool = true:
	set(value):
		active = value
		if value:
			active_component()
		else:
			deactive_compoment()

@export var allow_external_modification: bool = false

var component_context : Dictionary

func _enter_tree() -> void:
	_register_component()
	pass


func _exit_tree() -> void:
	_deregister_component()
	pass


## Pesudo Abstract function to set/get component's name
func get_component_name() -> StringName:
	return &""
	# pass

func get_component(_component_name: StringName) -> Object:
	if !owner: return null
	if !owner.has_meta(_component_name):
		return null

	var _projectile_component = owner.get_meta(_component_name)

	if _projectile_component is ProjectileComponent:
		return _projectile_component
	
	return null

func active_component() -> void:
	pass


func deactive_compoment() -> void:
	pass


func add_value(_value) -> void:
	pass


func multiple_value(_value) -> void:
	pass


func override_value(_value) -> void:
	pass


func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	pass


## register component when the component enter scene tree
func _register_component() -> void:
	if !owner: return
	## Using the base ProjectileComponent node, ignore the rest
	if get_script().get_global_name() == &"ProjectileComponent":
		return
	if !get_component_name() or get_component_name() == &"":
		push_warning("Registering %s component failed! get_component_name() is not implemented or component name is invalid " % name)
		return
	if owner.has_meta(get_component_name()):
		print_debug("Duplicated component: %s\n%s already have %s component" % [get_path(), owner, owner.get_meta(get_component_name())])
		return

	owner.set_meta(get_component_name(), self)

	component_registered.emit(owner, self)
	pass


## Deregister component when the component exit scene tree
func _deregister_component() -> void:
	if !owner: return
	if !owner.has_meta(get_component_name()): return
	owner.remove_meta(get_component_name())

	component_deregistered.emit(owner, self)
	pass


func process_projectile_component() -> Variant:
	return
