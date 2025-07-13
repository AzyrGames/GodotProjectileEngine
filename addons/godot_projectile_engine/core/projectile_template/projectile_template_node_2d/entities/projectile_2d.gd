extends Area2D
class_name Projectile2D

@export var speed : float = 100
@export var direction : Vector2 = Vector2.RIGHT
# @export var pooling_amount : int = 200
@export_group("Projectile Behavior")
@export_subgroup("Transform")

@export var speed_projectile_behaviors : Array[ProjectileBehaviorSpeed]
@export var direction_projectile_behaviors : Array[ProjectileBehaviorDirection]
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
var speed_final : float
var _speed_addition : float
var _speed_multiply : float
var _speed_behavior_values : Dictionary
var _speed_behavior_additions : Dictionary
var _speed_behavior_multiplies : Dictionary
var _speed_multiply_value : float

var base_direction : Vector2
var raw_direction : Vector2
var direction_final : Vector2
var _direction_behavior_values : Dictionary
var _direction_behavior_additions : Dictionary
var _direction_behavior_rotations : Dictionary
var _direction_rotation_value : float
var _direction_addition_value : Vector2
var _direction_addition : Vector2

var projectile_rotation : float
var base_rotation : float
var rotation_final : float
var _rotation_behavior_values : Dictionary
var _rotation_behavior_additions : Dictionary
var _rotation_behavior_multiplies : Dictionary
var _rotation_multiply_value : float
var _rotation_multiply : float
var _rotation_addition : float

var projectile_scale : Vector2
var base_scale : Vector2
var scale_final : Vector2
var _scale_behavior_values : Dictionary
var _scale_behavior_additions : Dictionary
var _scale_behavior_multiplies : Dictionary
var _scale_multiply_value : Vector2
var _scale_multiply : Vector2
var _scale_addition : Vector2

var projectile_behavior_context : Dictionary
var _behavior_context_requests_normal : Array[ProjectileEngine.BehaviorContext]
var _behavior_contest_requests_persist : Array[ProjectileEngine.BehaviorContext]
var _normal_behavior_context : Dictionary
var _persist_behavior_context : Dictionary

var projectile_behaviors : Array[ProjectileBehavior] = []

func _set(property: StringName, value: Variant) -> bool:
	match property:
		"rotation":
			rotation = value
			projectile_rotation = value
			base_rotation = value
			return true
		"scale":
			scale = value
			projectile_scale = value
			base_scale = value
			return true
	return true

func _ready() -> void:
	base_speed = speed
	base_direction = direction
	base_rotation = rotation
	projectile_rotation = rotation
	base_scale = scale
	projectile_scale = scale

	projectile_behaviors.clear()
	projectile_behaviors.append_array(speed_projectile_behaviors)
	projectile_behaviors.append_array(direction_projectile_behaviors)
	projectile_behaviors.append_array(rotation_projectile_behaviors)
	projectile_behaviors.append_array(scale_projectile_behaviors)
	projectile_behaviors.append_array(destroy_projectile_behaviors)
	projectile_behaviors.append_array(bouncing_projectile_behaviors)
	projectile_behaviors.append_array(piercing_projectile_behaviors)
	projectile_behaviors.append_array(trigger_projectile_behaviors)


	for _projectile_behavior in projectile_behaviors:
		if !_projectile_behavior: continue
		if !_projectile_behavior.active: continue
		_behavior_context_requests_normal.append_array(_projectile_behavior._request_behavior_context())
		_behavior_contest_requests_persist.append_array(_projectile_behavior._request_persist_behavior_context())
	
	## Special process
	for _projectile_behavior in projectile_behaviors:
		if _projectile_behavior is ProjectileDestroyImmediate:
			if _projectile_behavior.process_behavior(null, projectile_behavior_context):
				queue_free_projectile()

	pass

func _physics_process(delta: float) -> void:
	update_projectile_2d(delta)
	pass


func apply_pattern_composer_data(_pattern_composer_data: PatternComposerData) -> void:
	position = _pattern_composer_data.position
	direction = _pattern_composer_data.direction
	base_speed = speed
	base_direction = direction

func update_projectile_2d(delta: float) -> void:
	projectile_behavior_context.clear()
	_normal_behavior_context.clear()

	process_behavior_context_request(_normal_behavior_context, _behavior_context_requests_normal)

	for _persist_behavior_context_key in _persist_behavior_context.keys():
		if !_persist_behavior_context.has(_persist_behavior_context_key):
			_persist_behavior_context.erase(_persist_behavior_context_key)
		
	process_behavior_context_request(_persist_behavior_context, _behavior_contest_requests_persist)
	
	projectile_behavior_context.merge(_normal_behavior_context, true)
	projectile_behavior_context.merge(_persist_behavior_context, true)

	life_time_second += delta
	life_distance += velocity.length()

	# Free Projectile Behaviors
	for _projectile_behavior in projectile_behaviors:
		if _projectile_behavior is not ProjectileBehaviorDestroy:
			continue
		if _projectile_behavior.process_behavior(null, projectile_behavior_context):
			queue_free_projectile()

	# Refresh Projectile Behaviors process
	for _behavior_key in projectile_behavior_context.keys():
		if _behavior_key != ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
			continue
		for _behavior_variable in projectile_behavior_context.get(_behavior_key):
			if _behavior_variable is not BehaviorVariable: continue
			_behavior_variable.is_processed = false

	# Process Projectile Transform Behaviors
	_speed_behavior_additions.clear()
	_speed_behavior_multiplies.clear()

	_rotation_behavior_additions.clear()
	_rotation_behavior_multiplies.clear()

	_scale_behavior_additions.clear()
	_scale_behavior_multiplies.clear()

	_direction_behavior_rotations.clear()
	_direction_behavior_additions.clear()

	for _projectile_behavior in projectile_behaviors:
		if not _projectile_behavior is ProjectileBehavior:
			continue
		if not _projectile_behavior.active:
			continue
		if _projectile_behavior is ProjectileBehaviorSpeed:
			_speed_behavior_values = _projectile_behavior.process_behavior(speed, projectile_behavior_context)
			for _behavior_key in _direction_behavior_values.keys():
				match _behavior_key:
					"speed_overwrite":
						speed = _speed_behavior_values.get("speed_overwrite")
					"speed_addition":
						_speed_behavior_additions.get_or_add(_projectile_behavior, _speed_behavior_values.get("speed_addition"))
					"speed_multiply":
						_speed_behavior_multiplies.get_or_add(_projectile_behavior, _speed_behavior_values.get("speed_multiply"))

		elif _projectile_behavior is ProjectileBehaviorDirection:
			_direction_behavior_values = _projectile_behavior.process_behavior(direction, projectile_behavior_context)
			for _behavior_key in _direction_behavior_values.keys():
				match _behavior_key:
					"direction_overwrite":
						direction = _direction_behavior_values.get("direction_overwrite")
					"direction_rotation":
						_direction_behavior_rotations.get_or_add(_projectile_behavior, _direction_behavior_values.get("direction_rotation"))
					"direction_addition":
						_direction_behavior_additions.get_or_add(_projectile_behavior, _direction_behavior_values.get("direction_addition"))

		elif _projectile_behavior is ProjectileBehaviorRotation:
			_rotation_behavior_values = _projectile_behavior.process_behavior(projectile_rotation, projectile_behavior_context)
			for _behavior_key in _rotation_behavior_values.keys():
				match _behavior_key:
					"rotation_overwrite":
						projectile_rotation = _rotation_behavior_values.get("rotation_overwrite")
					"rotation_addition":
						_rotation_behavior_additions.get_or_add(_projectile_behavior, _rotation_behavior_values.get("rotation_addition"))
					"rotation_multiply":
						_rotation_behavior_multiplies.get_or_add(_projectile_behavior, _rotation_behavior_values.get("rotation_multiply"))			

		elif _projectile_behavior is ProjectileBehaviorScale:
			_scale_behavior_values = _projectile_behavior.process_behavior(projectile_scale, projectile_behavior_context)
			if _scale_behavior_values.size() <= 0:
				continue
			for _behavior_key in _scale_behavior_values.keys():
				match _behavior_key:
					"scale_overwrite":
						projectile_scale = _scale_behavior_values.get("scale_overwrite")
					"scale_addition":
						_scale_behavior_additions.get_or_add(_projectile_behavior, _scale_behavior_values.get("scale_addition"))
					"scale_multiply":
						_scale_behavior_multiplies.get_or_add(_projectile_behavior, _scale_behavior_values.get("scale_multiply"))

	# Apply Projectile behaviors
	rotation_final = projectile_rotation
	if _rotation_behavior_multiplies.size() > 0:
		_rotation_multiply_value = 0
		for _rotation_behavior_multiply in _rotation_behavior_multiplies.values():
			_rotation_multiply_value += _rotation_behavior_multiply
		_rotation_multiply = base_rotation * _rotation_multiply_value
		rotation_final += _rotation_multiply 

	if _rotation_behavior_additions.size() > 0:
		_rotation_addition = 0
		for _rotation_behavior_addition in _rotation_behavior_additions.values():
			_rotation_addition += _rotation_behavior_addition
		rotation_final += _rotation_addition 

	rotation = rotation_final

	scale_final = projectile_scale
	if _scale_behavior_multiplies.size() > 0:
		_scale_multiply_value = Vector2.ZERO
		for _scale_behavior_multiply in _scale_behavior_multiplies.values():
			_scale_multiply_value += _scale_behavior_multiply
		_scale_multiply = base_scale * _scale_multiply_value
		scale_final += _scale_multiply

	if _scale_behavior_additions.size() > 0:
		_scale_addition = Vector2.ZERO
		for _scale_behavior_addition in _scale_behavior_additions.values():
			_scale_addition += _scale_behavior_addition
		scale_final += _scale_addition

	scale = scale_final

	if _direction_behavior_rotations.size() > 0:
		for _direction_behavior_rotation in _direction_behavior_rotations.values():
			_direction_rotation_value += _direction_behavior_rotation

	if _direction_behavior_additions.size() > 0:
		for _direction_behavior_addition in _direction_behavior_additions.values():
			_direction_addition_value += _direction_behavior_addition
		_direction_addition = base_direction + _direction_addition_value

	if _direction_addition != Vector2.ZERO:
		direction = _direction_addition.normalized()

	if _direction_rotation_value != 0:
		direction = base_direction.rotated(_direction_rotation_value)

	direction = direction.normalized()

	speed_final = speed
	if _speed_behavior_multiplies.size() > 0:
		_speed_multiply_value = 0
		for _speed_behavior_multiply in _speed_behavior_multiplies.values():
			_speed_multiply_value += _speed_behavior_multiply
		_speed_multiply = base_speed * _speed_multiply_value
		speed_final += _speed_multiply

	if _speed_behavior_additions.size() > 0:
		_speed_addition = 0
		for _speed_behavior_addition in _speed_behavior_additions.values():
			_speed_addition += _speed_behavior_addition
		speed_final += _speed_addition

	velocity = speed_final * direction * delta
	global_position += velocity


func process_behavior_context_request(
	_behavior_context: Dictionary, 
	_behaviors_context_requests: Array[ProjectileEngine.BehaviorContext]
	) -> void:
	for _behaviors_context_request in _behaviors_context_requests:
		match _behaviors_context_request:
			ProjectileEngine.BehaviorContext.PHYSICS_DELTA:
				_behavior_context.get_or_add(_behaviors_context_request, get_physics_process_delta_time())

			ProjectileEngine.BehaviorContext.GLOBAL_POSITION:
				_behavior_context.get_or_add(_behaviors_context_request, global_position)

			ProjectileEngine.BehaviorContext.PROJECTILE_OWNER:
				_behavior_context.get_or_add(_behaviors_context_request, owner)

			ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER:
				_behavior_context.get_or_add(_behaviors_context_request, self)
	
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
				_behavior_context.get_or_add(_behaviors_context_request, projectile_rotation)

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
	#todo: emit destroy signal
	queue_free()
	pass
