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


func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	pass


func update_behavior_context(_behaviors: Array[ProjectileBehavior]) -> void:
	var _behavior_contexts: Array[ProjectileEngine.BehviorContext] = []
	for _behavior in _behaviors:
		if !_behavior: continue
		if !_behavior.active: continue
		_behavior_contexts.append_array(_behavior._behavior_context_request())
	component_context.clear()
	for _behavior_context in _behavior_contexts:
		if component_context.has(_behavior_context): continue
		match _behavior_context:
			ProjectileEngine.BehviorContext.PHYSICS_DELTA:
				component_context.get_or_add(
					ProjectileEngine.BehviorContext.PHYSICS_DELTA,
					get_physics_process_delta_time()
					)
			ProjectileEngine.BehviorContext.LIFE_TIME_SECOND:
				var _projectile_component := get_component("projectile_component_life_time")
				if !_projectile_component: continue ## Todo: Maybe add a warning here
				var _life_time_second = _projectile_component.life_time_second
				component_context.get_or_add(
					ProjectileEngine.BehviorContext.LIFE_TIME_SECOND, 
					_life_time_second
					)
				pass
			ProjectileEngine.BehviorContext.BASE_SPEED:
				var _projectile_component := get_component("projectile_component_speed")
				if !_projectile_component: continue ## Todo: Maybe add a warning here
				component_context.get_or_add(
					ProjectileEngine.BehviorContext.BASE_SPEED, 
					_projectile_component.base_speed
					)
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
