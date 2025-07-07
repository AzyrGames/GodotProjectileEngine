extends Area2D
class_name Projectile2D

@export var speed : float = 100
@export var direction : Vector2 = Vector2.RIGHT
@export_group("Projectile Behavior")
@export_subgroup("Transform")

@export var speed_projectile_behaviors : Array[ProjectileBehaviorSpeed]
@export var direction_projectile_behaviors : Array[ProjectileBehaviorDirection]
@export var homing_projectile_behaviors : Array[ProjectileBehaviorHoming] = []
@export var rotation_projectile_behaviors : Array[ProjectileBehaviorRotation]
@export var scale_projectile_behaviors : Array[ProjectileBehaviorScale]

@export_subgroup("Special")
@export var destroy_projectile_behaviors : Array[ProjectileBehaviorDestroy]
@export var piercing_projectile_behaviors : Array[ProjectileBehaviorPiercing]
@export var bouncing_projectile_behaviors : Array[ProjectileBehaviorBouncing]
@export var trigger_projectile_behaviors : Array[ProjectileBehaviorTrigger]

var velocity : Vector2
var life_time_second: float
var life_distance : float
var base_speed : float

var base_direction : Vector2
var raw_direction : Vector2
var direction_rotation : float
var direction_addition : Vector2
var direction_final : Vector2


var projectile_behavior_context : Dictionary
var _normal_behavior_context : Dictionary
var _persist_behavior_context : Dictionary

var projectile_behaviors : Array[ProjectileBehavior] = []

# var component_behaviors : Array[ProjectileBehavior]
# var _component_behavior_contexts: Array[ProjectileEngine.BehaviorContext] = []
# var _persist_component_behavior_contexts: Array[ProjectileEngine.BehaviorContext] = []

func _ready() -> void:
	pass
	# for _meta in get_meta_list():
	# 	if get_meta(_meta) is ProjectileComponent:
	# 		pass
	# 		if "component_behaviors" in get_meta(_meta):
	# 			component_behaviors.append_array(get_meta(_meta).component_behaviors)

	# for _behavior in component_behaviors:
	# 	if !_behavior: continue
	# 	if !_behavior.active: continue
	# 	_component_behavior_contexts.append_array(_behavior._request_behavior_context())
	# 	_persist_component_behavior_contexts.append_array(_behavior._request_persist_behavior_context())

func _physics_process(delta: float) -> void:
	update_projectile_2d(delta)
	pass


func apply_pattern_composer_data(_pattern_composer_data: PatternComposerData) -> void:
	position = _pattern_composer_data.position
	direction = _pattern_composer_data.direction
	rotation = _pattern_composer_data.rotation


func update_projectile_2d(delta: float) -> void:
	projectile_behaviors.clear()
	projectile_behaviors.append_array(speed_projectile_behaviors)
	projectile_behaviors.append_array(direction_projectile_behaviors)
	projectile_behaviors.append_array(rotation_projectile_behaviors)
	projectile_behaviors.append_array(scale_projectile_behaviors)
	projectile_behaviors.append_array(destroy_projectile_behaviors)
	projectile_behaviors.append_array(homing_projectile_behaviors)
	projectile_behaviors.append_array(bouncing_projectile_behaviors)
	projectile_behaviors.append_array(piercing_projectile_behaviors)
	projectile_behaviors.append_array(trigger_projectile_behaviors)

	var _behavior_context_requests_normal : Array[ProjectileEngine.BehaviorContext]
	var _behavior_contest_requests_persist : Array[ProjectileEngine.BehaviorContext]

	for _projectile_behavior in projectile_behaviors:
		if !_projectile_behavior: continue
		if !_projectile_behavior.active: continue
		_behavior_context_requests_normal.append_array(_projectile_behavior._request_behavior_context())
		_behavior_contest_requests_persist.append_array(_projectile_behavior._request_persist_behavior_context())

	projectile_behavior_context.clear()

	_normal_behavior_context.clear()
	process_behavior_context_request(_normal_behavior_context, _behavior_context_requests_normal)

	for _persist_behavior_context_key in _persist_behavior_context.keys():
		if !_persist_behavior_context.has(_persist_behavior_context_key):
			_persist_behavior_context.erase(_persist_behavior_context_key)
		
	process_behavior_context_request(_persist_behavior_context, _behavior_contest_requests_persist)
	
	projectile_behavior_context.merge(_normal_behavior_context, true)
	projectile_behavior_context.merge(_persist_behavior_context, true)

	for _behavior_key in projectile_behavior_context.keys():
		if _behavior_key == ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
			for _behavior_variable in projectile_behavior_context.get(_behavior_key):
				if _behavior_variable is not BehaviorVariable: continue
				_behavior_variable.is_processed = false

	life_time_second += delta
	life_distance += velocity.length()

	for _projectile_behavior in projectile_behaviors:
		if _projectile_behavior is ProjectileBehaviorDestroy:
			if _projectile_behavior.process_behavior(null, projectile_behavior_context):
				queue_free_projectile()

	for _behavior_key in projectile_behavior_context.keys():
		if _behavior_key == ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
			for _behavior_variable in projectile_behavior_context.get(_behavior_key):
				if _behavior_variable is not BehaviorVariable: continue
				_behavior_variable.is_processed = false

	for _projectile_behavior in projectile_behaviors:
		if _projectile_behavior is ProjectileBehaviorSpeed:
			speed = _projectile_behavior.process_behavior(speed, projectile_behavior_context)
		elif _projectile_behavior is ProjectileBehaviorDirection:
			var _new_direction_array: Array
			_new_direction_array = _projectile_behavior.process_behavior(direction, projectile_behavior_context)
			if _new_direction_array[0] != direction:
				raw_direction = _new_direction_array[0]
				direction = raw_direction.normalized()

			if _new_direction_array.size() == 2:
				direction_rotation = _new_direction_array[1]

			if _new_direction_array.size() == 3:
				direction_addition = _new_direction_array[2]

		elif _projectile_behavior is ProjectileBehaviorScale:
			scale = _projectile_behavior.process_behavior(scale, projectile_behavior_context)
		elif _projectile_behavior is ProjectileBehaviorRotation:
			rotation = _projectile_behavior.process_behavior(rotation, projectile_behavior_context)
		elif _projectile_behavior is ProjectileBehaviorHoming:
			# speed = _projectile_behavior.process_behavior(speed, projectile_behavior_context)
			var _homing_result: Array = _projectile_behavior.process_behavior(direction, projectile_behavior_context)
	
			if _homing_result.size() > 0 and _homing_result[0] != direction:
				# Apply the new direction from homing behavior
				raw_direction = _homing_result[0]
				direction = raw_direction.normalized()
	
		elif _projectile_behavior is ProjectileBehaviorSpeed:
			speed = _projectile_behavior.process_behavior(speed, projectile_behavior_context)

	direction_final = direction
	if direction_addition != Vector2.ZERO:
		direction_final = (direction_final + direction_addition).normalized()
	if direction_rotation != 0.0:
		direction_final = base_direction.normalized().rotated(direction_rotation)

	direction = direction_final

	velocity = speed * direction * delta
	global_position += velocity


func process_behavior_context_request(_behavior_context: Dictionary, _behaviors_context_requests: Array[ProjectileEngine.BehaviorContext]) -> void:
	for _behaviors_context_request in _behaviors_context_requests:
		match _behaviors_context_request:
			ProjectileEngine.BehaviorContext.PHYSICS_DELTA:
				_behavior_context.get_or_add(_behaviors_context_request, get_physics_process_delta_time())

			ProjectileEngine.BehaviorContext.GLOBAL_POSITION:
				_behavior_context.get_or_add(_behaviors_context_request, global_position)

			ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND:
				_behavior_context.get_or_add(_behaviors_context_request, life_time_second)

			ProjectileEngine.BehaviorContext.LIFE_DISTANCE:
				_behavior_context.get_or_add(_behaviors_context_request, life_distance)

			ProjectileEngine.BehaviorContext.BASE_SPEED:
				_behavior_context.get_or_add(_behaviors_context_request, base_speed)

			ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
				_behavior_context.get_or_add(_behaviors_context_request, [])

			ProjectileEngine.BehaviorContext.DIRECTION:
				_behavior_context.get_or_add(_behaviors_context_request, direction)

			ProjectileEngine.BehaviorContext.BASE_DIRECTION:
				_behavior_context.get_or_add(_behaviors_context_request, base_direction)

			ProjectileEngine.BehaviorContext.ROTATION:
				_behavior_context.get_or_add(_behaviors_context_request, rotation)

			ProjectileEngine.BehaviorContext.BASE_SCALE:
				_behavior_context.get_or_add(_behaviors_context_request, scale)

			ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR:
				var _rng_array := []
				_rng_array.append(RandomNumberGenerator.new())
				_rng_array.append(false)
				_behavior_context.get_or_add(_behaviors_context_request, _rng_array)

			_:
				pass
	return 

func queue_free_projectile() -> void:
	#todo: Add projectile global destroyed signal

	queue_free()
	pass

# func process_behavior_context_request(_behavior_context: ProjectileEngine.BehaviorContext) -> Variant:
# 	match _behavior_context:
# 		ProjectileEngine.BehaviorContext.PHYSICS_DELTA:
# 			return get_physics_process_delta_time()

# 		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND:
# 			var _projectile_component := get_component("projectile_component_life_time")
# 			if !_projectile_component: return null ## Todo: Maybe add a warning here
# 			return _projectile_component.life_time_second

# 		ProjectileEngine.BehaviorContext.LIFE_DISTANCE:
# 			var _projectile_component := get_component("projectile_component_life_distance")
# 			if !_projectile_component: return null ## Todo: Maybe add a warning here
# 			return _projectile_component.life_distance

# 		ProjectileEngine.BehaviorContext.BASE_SPEED:
# 			var _projectile_component := get_component("projectile_component_speed")
# 			if !_projectile_component: return null ## Todo: Maybe add a warning here
# 			return _projectile_component.base_speed

# 		ProjectileEngine.BehaviorContext.DIRECTION_COMPONENT:
# 			var _projectile_component := get_component("projectile_component_direction")
# 			if !_projectile_component: return null ## Todo: Maybe add a warning here
# 			return _projectile_component

# 		ProjectileEngine.BehaviorContext.DIRECTION:
# 			var _projectile_component := get_component("projectile_component_direction")
# 			if !_projectile_component: return null ## Todo: Maybe add a warning here
# 			return _projectile_component.get_direction()

# 		ProjectileEngine.BehaviorContext.BASE_DIRECTION:
# 			var _projectile_component := get_component("projectile_component_direction")
# 			if !_projectile_component: return null ## Todo: Maybe add a warning here
# 			return _projectile_component.base_direction

# 		ProjectileEngine.BehaviorContext.ROTATION:
# 			var _projectile_component := get_component("projectile_component_rotation")
# 			if !_projectile_component: return null ## Todo: Maybe add a warning here
# 			return _projectile_component.get_rotation()

# 		ProjectileEngine.BehaviorContext.BASE_SCALE:
# 			var _projectile_component := get_component("projectile_component_scale")
# 			if !_projectile_component: return null ## Todo: Maybe add a warning here
# 			return _projectile_component.base_scale

# 		ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR:
# 			var _rng_array := []
# 			_rng_array.append(RandomNumberGenerator.new())
# 			_rng_array.append(false)
# 			return _rng_array

# 		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
# 			return []
# 		_:
			
# 			return null

# 	return null

# func get_component(_component_name: StringName) -> Object:
# 	if has_meta(_component_name):
# 		return null

# 	var _projectile_component = get_meta(_component_name)

# 	if _projectile_component is ProjectileComponent:
# 		return _projectile_component

# 	return null


## Do not touch this
## Reset projectile components when reused
# func reset() -> void:
# 	if has_meta("projectile_component_piercing"):
# 		get_meta("projectile_component_piercing").reset()
	
# 	# Add reset calls for other components as needed
