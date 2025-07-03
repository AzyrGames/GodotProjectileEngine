extends Area2D
class_name Projectile2D

var behavior_context : Dictionary

var _normal_behavior_context : Dictionary
var _persist_behavior_context : Dictionary

var component_behaviors : Array[ProjectileBehavior]
var _component_behavior_contexts: Array[ProjectileEngine.BehaviorContext] = []
var _persist_component_behavior_contexts: Array[ProjectileEngine.BehaviorContext] = []
func _ready() -> void:
	for _meta in get_meta_list():
		if get_meta(_meta) is ProjectileComponent:
			pass
			if "component_behaviors" in get_meta(_meta):
				component_behaviors.append_array(get_meta(_meta).component_behaviors)
	


	for _behavior in component_behaviors:
		if !_behavior: continue
		if !_behavior.active: continue
		_component_behavior_contexts.append_array(_behavior._request_behavior_context())
		_persist_component_behavior_contexts.append_array(_behavior._request_persist_behavior_context())


func _physics_process(delta: float) -> void:
	if _component_behavior_contexts.is_empty() and _persist_component_behavior_contexts.is_empty():
		return
	update_behavior_context(component_behaviors)
	pass

func update_behavior_context(_behaviors: Array[ProjectileBehavior]) -> void:
	behavior_context.clear()

	_normal_behavior_context.clear()
	for _behavior_context in _component_behavior_contexts:
		_normal_behavior_context.get_or_add(
			_behavior_context, 
			process_behavior_context_request(_behavior_context)
			)

	for _persist_behavior_context_key in _persist_behavior_context.keys():
		if !_persist_component_behavior_contexts.has(_persist_behavior_context_key):
			_persist_behavior_context.erase(_persist_behavior_context_key)

	for _persist_behavior_context_key in _persist_component_behavior_contexts:
		if _persist_behavior_context.has(_persist_behavior_context_key):
			continue
		_persist_behavior_context.get_or_add(
			_persist_behavior_context_key, 
			process_behavior_context_request(_persist_behavior_context_key)
			)

	behavior_context.merge(_normal_behavior_context, true)
	behavior_context.merge(_persist_behavior_context, true)

	for _behavior_key in behavior_context.keys():
		if _behavior_key == ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
			for _behavior_variable in behavior_context.get(_behavior_key):
				if _behavior_variable is not BehaviorVariable: continue
				_behavior_variable.is_processed = false

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

func get_component(_component_name: StringName) -> Object:
	if has_meta(_component_name):
		return null

	var _projectile_component = get_meta(_component_name)

	if _projectile_component is ProjectileComponent:
		return _projectile_component

	return null

func apply_pattern_composer_data(_pattern_composer_data: PatternComposerData) -> void:
	# print(_pattern_composer_data)
	if has_meta("projectile_component_position"):
		get_meta("projectile_component_position").position = _pattern_composer_data.position

	if has_meta("projectile_component_direction"):
		get_meta("projectile_component_direction").direction = _pattern_composer_data.direction

	if has_meta("projectile_component_rotation"):
		get_meta("projectile_component_rotation").rotation = _pattern_composer_data.rotation

	if has_meta("projectile_component_speed"):
		get_meta("projectile_component_speed").speed_mod = _pattern_composer_data.speed_mod

	if has_meta("projectile_component_transform_2d"):
		get_meta("projectile_component_transform_2d").update_projectile_transform_2d()

## Do not touch this
## Reset projectile components when reused
# func reset() -> void:
# 	if has_meta("projectile_component_piercing"):
# 		get_meta("projectile_component_piercing").reset()
	
# 	# Add reset calls for other components as needed
