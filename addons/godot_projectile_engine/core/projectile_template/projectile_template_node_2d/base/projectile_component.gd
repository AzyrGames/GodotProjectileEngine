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
			deactivate_component()

var component_context : Dictionary

var _normal_component_context : Dictionary
var _persist_component_context : Dictionary

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


func deactivate_component() -> void:
	pass


func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	pass


func update_behavior_context(_behaviors: Array[ProjectileBehavior]) -> void:
	var _behavior_contexts: Array[ProjectileEngine.BehaviorContext] = []
	var _persist_behavior_contexts: Array[ProjectileEngine.BehaviorContext] = []

	for _behavior in _behaviors:
		if !_behavior: continue
		if !_behavior.active: continue
		_behavior_contexts.append_array(_behavior._request_behavior_context())
		_persist_behavior_contexts.append_array(_behavior._request_persist_behavior_context())

	component_context.clear()

	if _behavior_contexts.is_empty() and _persist_behavior_contexts.is_empty():
		return

	_normal_component_context.clear()
	for _behavior_context in _behavior_contexts:
		_normal_component_context.get_or_add(
			_behavior_context, 
			process_behavior_context_request(_behavior_context)
			)

	for _persist_behavior_context in _persist_component_context.keys():
		if !_persist_behavior_contexts.has(_persist_behavior_context):
			_persist_component_context.erase(_persist_behavior_context)

	for _persist_behavior_context in _persist_behavior_contexts:
		if _persist_component_context.has(_persist_behavior_context):
			continue
		_persist_component_context.get_or_add(
			_persist_behavior_context, 
			process_behavior_context_request(_persist_behavior_context)
			)
	
	component_context.merge(_normal_component_context, true)
	component_context.merge(_persist_component_context, true)


func process_behavior_context_request(_behavior_context: ProjectileEngine.BehaviorContext) -> Variant:
	match _behavior_context:
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA:
			return get_physics_process_delta_time()

		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND:
			var _projectile_component := get_component("projectile_component_life_time")
			if !_projectile_component: return null ## Todo: Maybe add a warning here
			return _projectile_component.life_time_second

		ProjectileEngine.BehaviorContext.LIFE_DISTANCE:
			var _projectile_component := get_component("projectile_component_life_distance")
			if !_projectile_component: return null ## Todo: Maybe add a warning here
			return _projectile_component.life_distance

		ProjectileEngine.BehaviorContext.BASE_SPEED:
			var _projectile_component := get_component("projectile_component_speed")
			if !_projectile_component: return null ## Todo: Maybe add a warning here
			return _projectile_component.base_speed

		ProjectileEngine.BehaviorContext.DIRECTION_COMPONENT:
			var _projectile_component := get_component("projectile_component_direction")
			if !_projectile_component: return null ## Todo: Maybe add a warning here
			return _projectile_component

		ProjectileEngine.BehaviorContext.DIRECTION:
			var _projectile_component := get_component("projectile_component_direction")
			if !_projectile_component: return null ## Todo: Maybe add a warning here
			return _projectile_component.get_direction()

		ProjectileEngine.BehaviorContext.BASE_DIRECTION:
			var _projectile_component := get_component("projectile_component_direction")
			if !_projectile_component: return null ## Todo: Maybe add a warning here
			return _projectile_component.base_direction

		ProjectileEngine.BehaviorContext.ROTATION:
			var _projectile_component := get_component("projectile_component_rotation")
			if !_projectile_component: return null ## Todo: Maybe add a warning here
			return _projectile_component.get_rotation()

		ProjectileEngine.BehaviorContext.BASE_SCALE:
			var _projectile_component := get_component("projectile_component_scale")
			if !_projectile_component: return null ## Todo: Maybe add a warning here
			return _projectile_component.base_scale

		ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR:
			var _rng_array := []
			_rng_array.append(RandomNumberGenerator.new())
			_rng_array.append(false)
			return _rng_array

		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
			return []
		_:
			
			return null

	return null


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
