extends Node2D
class_name ProjectileUpdaterCustom2D

var projectile_template_2d : ProjectileTemplateCustom2D

var projectile_damage: float = 1.0
var projectile_speed : float = 100.0

var projectile_rotation_speed : float

var projectile_texture : Texture2D
var projectile_texture_rotation : float
var projectile_texture_visible : bool
var projectile_texture_modulate : Color

var projectile_texture_draw_offset : Vector2

var projectile_collision_shape : Shape2D
var projectile_collision_layer : int = 0
var projectile_collision_mask : int = 0


var projectile_pooling_index : int = 0
var projectile_max_pooling : int

var projectile_area_rid : RID

var projectile_instance_array : Array
var projectile_active_index : Array

var projectile_remove_index : Array = []


var PS := PhysicsServer2D

var spawner_destroyed : bool = false

var _active_instances : Array[ProjectileInstanceCustom2D]
var _projectile_instance : ProjectileInstanceCustom2D


func _ready() -> void:
	setup_projectile_updater()


func _physics_process(delta: float) -> void:
	update_projectile_instances(delta)
	
	# Free Projectile Updater after spawner destroyed and no active projectile instances
	if spawner_destroyed and projectile_active_index.size() <= 0:
		clear_projectile_updater()
		queue_free()

	queue_redraw()
	pass


func _draw() -> void:
	draw_projectile_texture()


#region Setup Projectile

func setup_projectile_updater() -> void:
	init_updater_variable()
	setup_projectile_area_rid()
	create_projectile_pool()
	pass

func setup_projectile_area_rid() -> void:

	projectile_area_rid = PS.area_create()

	PS.area_set_space(projectile_area_rid, get_world_2d().space)
	PS.area_set_collision_layer(projectile_area_rid, projectile_template_2d.collision_layer)
	PS.area_set_collision_mask(projectile_area_rid, projectile_template_2d.collision_mask)
	PS.area_set_monitorable(projectile_area_rid, true)
	PS.area_set_transform(projectile_area_rid, Transform2D())
	setup_area_callback(projectile_area_rid)

	projectile_template_2d.projectile_area_rid = projectile_area_rid

func create_projectile_pool() -> void:
	var _transform := Transform2D()
	var _collision_rid : RID = 	projectile_template_2d.collision_shape.get_rid()

	projectile_max_pooling = projectile_template_2d.projectile_pooling_amount

	for _index in range(projectile_max_pooling):
		PS.area_add_shape(projectile_area_rid, _collision_rid, _transform, true)

		_projectile_instance = ProjectileInstanceCustom2D.new()

		_projectile_instance.area_rid = projectile_area_rid
		_projectile_instance.area_index = _index


		projectile_instance_array.append(_projectile_instance)

func init_updater_variable() -> void:
	projectile_damage = projectile_template_2d.damage
	projectile_speed = projectile_template_2d.speed
	# projectile_life_time_max  = projectile_template_2d.life_time_max
	# projectile_life_distance_max  = projectile_template_2d.life_distance_max
	pass

func setup_area_callback(_projectile_area: RID) -> void:
	PS.area_set_monitor_callback(_projectile_area, _body_monitor_callback)
	PS.area_set_area_monitor_callback(_projectile_area, _area_monitor_callback)
	pass


func _body_monitor_callback(status: int, body_rid : RID, instance_id: int, body_shape_idx: int, self_shape_idx:int) -> void:
	if status == PS.AREA_BODY_ADDED:
		ProjectileEngine.projectile_instance_body_shape_entered.emit(
			projectile_instance_array[self_shape_idx],
			body_rid, instance_from_id(instance_id), body_shape_idx,
			projectile_area_rid, self_shape_idx
		)

		ProjectileEngine.projectile_instance_body_entered.emit(
			projectile_instance_array[self_shape_idx], instance_from_id(instance_id)
		)
	elif PS.AREA_BODY_REMOVED:
		ProjectileEngine.projectile_instance_body_shape_exited.emit(
			projectile_instance_array[self_shape_idx],
			body_rid, instance_from_id(instance_id), body_shape_idx,
			projectile_area_rid, self_shape_idx
		)

		ProjectileEngine.projectile_instance_body_exited.emit(
			projectile_instance_array[self_shape_idx], instance_from_id(instance_id)
		)
		pass


func _area_monitor_callback(status: int, area_rid : RID, instance_id: int, area_shape_idx: int, self_shape_idx:int) -> void:
	if status == PS.AREA_BODY_ADDED:
		ProjectileEngine.projectile_instance_area_shape_entered.emit(
			projectile_instance_array[self_shape_idx],
			area_rid, instance_from_id(instance_id), area_shape_idx,
			projectile_area_rid, self_shape_idx
		)

		ProjectileEngine.projectile_instance_area_entered.emit(
			projectile_instance_array[self_shape_idx], instance_from_id(instance_id)
		)
	elif PS.AREA_BODY_REMOVED:
		ProjectileEngine.projectile_instance_area_shape_exited.emit(
			projectile_instance_array[self_shape_idx],
			area_rid, instance_from_id(instance_id), area_shape_idx,
			projectile_area_rid, self_shape_idx
		)

		ProjectileEngine.projectile_instance_area_exited.emit(
			projectile_instance_array[self_shape_idx], instance_from_id(instance_id)
		)
		pass


func process_projectile_collided(instance_index: int) -> void:
	if instance_index not in projectile_remove_index:
		projectile_remove_index.append(instance_index)
	pass

#endregion


#region Spawn Projectile 

func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	for pattern_data : PatternComposerData in pattern_composer_pack:

		_projectile_instance = projectile_instance_array[projectile_pooling_index]
		_projectile_instance.global_position = pattern_data.position
		_projectile_instance.speed = projectile_speed
		_projectile_instance.base_speed = projectile_speed

		_projectile_instance.velocity = pattern_data.direction * projectile_speed * (1.0 / Engine.physics_ticks_per_second)

		_projectile_instance.direction = pattern_data.direction
		
		_projectile_instance.base_direction = pattern_data.direction

		_projectile_instance.scale = projectile_template_2d.scale

		_projectile_instance.life_time_second = 0.0
		_projectile_instance.life_distance = 0.0

		_projectile_instance.trigger_count = 0

		_projectile_instance.transform = Transform2D(
			projectile_template_2d.rotation, 
			projectile_template_2d.scale,
			projectile_template_2d.texture_skew,
			_projectile_instance.global_position
			)

		PS.area_set_shape_transform(projectile_area_rid, projectile_pooling_index, _projectile_instance.transform)
		PS.area_set_shape_disabled(projectile_area_rid, projectile_pooling_index, false)
	
		projectile_instance_array[projectile_pooling_index] = _projectile_instance

		if projectile_pooling_index not in projectile_active_index:
			projectile_active_index.append(projectile_pooling_index)


		projectile_pooling_index += 1
		
		if projectile_pooling_index >= projectile_max_pooling:
			projectile_pooling_index = 0

#endregion


#region Update Projectile

var projectile_behavior_context : Dictionary
var projectile_behaviors : Array[ProjectileBehavior] = []


func update_projectile_instances(delta: float) -> void:
	projectile_damage = projectile_template_2d.damage

	projectile_speed = projectile_template_2d.speed

	# projectile_life_time_max  = projectile_template_2d.life_time_max
	# projectile_life_distance_max  = projectile_template_2d.life_distance_max
	projectile_behaviors.clear()
	projectile_behaviors.append_array(projectile_template_2d.speed_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.direction_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.rotation_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.scale_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.destroy_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.homing_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.bouncing_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.piercing_projectile_behaviors)
	projectile_behaviors.append_array(projectile_template_2d.trigger_projectile_behaviors)

	var _behavior_requests_contexts : Array[ProjectileEngine.BehaviorContext]
	var _behavior_requests_persist_contexts : Array[ProjectileEngine.BehaviorContext]

	for _projectile_behvior in projectile_behaviors:
		if !_projectile_behvior: continue
		if !_projectile_behvior.active: continue
		_behavior_requests_contexts.append_array(_projectile_behvior._request_behavior_context())
		_behavior_requests_persist_contexts.append_array(_projectile_behvior._request_persist_behavior_context())

	projectile_behavior_context.clear()

	
	# Check for projectile destroy condition
	for index : int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]
		
		_projectile_instance.life_time_second += delta
		_projectile_instance.life_distance += _projectile_instance.velocity.length()
		_projectile_instance.behavior_context.clear()
		_projectile_instance.behavior_update_context.clear()
		process_behavior_context_request(_projectile_instance.behavior_update_context, _projectile_instance, _behavior_requests_contexts)
		process_behavior_context_request(_projectile_instance.behavior_persist_context, _projectile_instance, _behavior_requests_persist_contexts)
		_projectile_instance.behavior_context.merge(_projectile_instance.behavior_update_context)
		_projectile_instance.behavior_context.merge(_projectile_instance.behavior_persist_context)

		for _projectile_behvior in projectile_behaviors:
			if _projectile_behvior is ProjectileBehaviorDestroy:
				if _projectile_behvior.process_behavior(null, _projectile_instance.behavior_context):
					projectile_remove_index.append(index)


	# Destroy projectile
	if projectile_remove_index.size() > 0:
		for index : int in projectile_remove_index:
			projectile_active_index.erase(index)
			PS.area_set_shape_disabled(projectile_area_rid, index, true)
		projectile_remove_index.clear()

	# Update active projectile instances array
	_active_instances.clear()
	for index : int in projectile_active_index:
		_active_instances.append(projectile_instance_array[index])
	if _active_instances.size() <= 0: return
	# Update active projectile
	
	for _active_instance : ProjectileInstanceCustom2D in _active_instances:

		for _projectile_behvior in projectile_behaviors:
			if _projectile_behvior is ProjectileBehaviorSpeed:
				_active_instance.speed = _projectile_behvior.process_behavior(_active_instance.speed, _active_instance.behavior_context)
			elif _projectile_behvior is ProjectileBehaviorDirection:
				var _new_direction_array: Array
				_new_direction_array = _projectile_behvior.process_behavior(_active_instance.direction, _active_instance.behavior_context)
				if _new_direction_array[0] != _active_instance.direction:
					_active_instance.raw_direction = _new_direction_array[0]
					_active_instance.direction = _active_instance.raw_direction.normalized()

				if _new_direction_array.size() == 2:
					_active_instance.direction_rotation = _new_direction_array[1]

				if _new_direction_array.size() == 3:
					_active_instance.direction_addition = _new_direction_array[2]

			elif _projectile_behvior is ProjectileBehaviorScale:
				_active_instance.scale = _projectile_behvior.process_behavior(_active_instance.scale, _active_instance.behavior_context)
			elif _projectile_behvior is ProjectileBehaviorRotation:
				_active_instance.rotation = _projectile_behvior.process_behavior(_active_instance.rotation, _active_instance.behavior_context)
			elif _projectile_behvior is ProjectileBehaviorHoming:
				# _active_instance.speed = _projectile_behvior.process_behavior(_active_instance.speed, _active_instance.behavior_context)
				var _homing_result: Array = _projectile_behvior.process_behavior(_active_instance.direction, _active_instance.behavior_context)
		
				if _homing_result.size() > 0 and _homing_result[0] != _active_instance.direction:
					# Apply the new direction from homing behavior
					_active_instance.raw_direction = _homing_result[0]
					_active_instance.direction = _active_instance.raw_direction.normalized()
		
			elif _projectile_behvior is ProjectileBehaviorSpeed:
				_active_instance.speed = _projectile_behvior.process_behavior(_active_instance.speed, _active_instance.behavior_context)

		_active_instance.direction_final = _active_instance.direction
		if _active_instance.direction_addition != Vector2.ZERO:
			_active_instance.direction_final = (_active_instance.direction_final + _active_instance.direction_addition).normalized()
		if _active_instance.direction_rotation != 0.0:
			_active_instance.direction_final = _active_instance.base_direction.normalized().rotated(_active_instance.direction_rotation)

		_active_instance.direction = _active_instance.direction_final

		_active_instance.velocity = _active_instance.speed * _active_instance.direction * delta
		_active_instance.global_position += _active_instance.velocity

		_active_instance.transform = Transform2D(
			_active_instance.rotation,
			_active_instance.scale,
			0.0,
			_active_instance.global_position
			)

		PS.area_set_shape_transform(projectile_area_rid, _active_instance.area_index, _active_instance.transform)


func update_projectile_behavior_context() -> void:
	pass

var behavior_static_context : Dictionary
var behavior_dynamic_context : Dictionary
var behavior_persist_context : Dictionary


func process_behavior_context_request(_current_context: Dictionary, _projectile_instance: ProjectileInstanceCustom2D, _behavior_contexts: Array[ProjectileEngine.BehaviorContext]) -> void:
	for _behavior_context in _behavior_contexts:
		match _behavior_context:
			ProjectileEngine.BehaviorContext.PHYSICS_DELTA:
				_current_context.get_or_add(_behavior_context, get_physics_process_delta_time())

			ProjectileEngine.BehaviorContext.GLOBAL_POSITION:
				_current_context.get_or_add(_behavior_context, _projectile_instance.global_position)

			ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND:
				_current_context.get_or_add(_behavior_context, _projectile_instance.life_time_second)

			ProjectileEngine.BehaviorContext.LIFE_DISTANCE:
				_current_context.get_or_add(_behavior_context, _projectile_instance.life_distance)

			ProjectileEngine.BehaviorContext.BASE_SPEED:
				_current_context.get_or_add(_behavior_context, _projectile_instance.base_speed)

			ProjectileEngine.BehaviorContext.ARRAY_VARIABLE:
				_current_context.get_or_add(_behavior_context, [])

			# ProjectileEngine.BehaviorContext.DIRECTION_COMPONENT:
			# 	var _projectile_component := get_component("projectile_component_direction")
			# 	if !_projectile_component: return null ## Todo: Maybe add a warning here
			# 	return _projectile_component

			ProjectileEngine.BehaviorContext.DIRECTION:
				_current_context.get_or_add(_behavior_context, _projectile_instance.direction)


			ProjectileEngine.BehaviorContext.BASE_DIRECTION:
				_current_context.get_or_add(_behavior_context, _projectile_instance.base_direction)


			ProjectileEngine.BehaviorContext.ROTATION:
				_current_context.get_or_add(_behavior_context, _projectile_instance.rotation)


			ProjectileEngine.BehaviorContext.BASE_SCALE:
				_current_context.get_or_add(_behavior_context, _projectile_instance.scale)


			ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR:
				var _rng_array := []
				_rng_array.append(RandomNumberGenerator.new())
				_rng_array.append(false)
				_current_context.get_or_add(_behavior_context, _rng_array)

			_:
				pass
			# 	return null
	return 

#endregion


#region Draw Projectile

func draw_projectile_texture() -> void:
	if !projectile_template_2d.texture_visible: return
	z_index = projectile_template_2d.texture_z_index
	projectile_texture = projectile_template_2d.texture
	projectile_texture_modulate = projectile_template_2d.texture_modulate
	projectile_texture_draw_offset = Vector2.ZERO - projectile_template_2d.texture.get_size() * 0.5

	for index : int in projectile_active_index:
		draw_set_transform_matrix(projectile_instance_array[index].transform)
		draw_texture(projectile_texture, projectile_texture_draw_offset, projectile_texture_modulate)

#endregion


func clear_projectile_updater() -> void:
	for instance : ProjectileInstanceCustom2D in projectile_instance_array:
		instance.queue_free()
		PS.area_clear_shapes(projectile_area_rid)


func get_active_projectile_count() -> int:
	return _active_instances.size()
	pass

func clear_projectile() -> void:
	for _index in range(projectile_max_pooling):
		projectile_active_index.erase(_index)
		PS.area_set_shape_disabled(projectile_area_rid, _index, true)
	projectile_active_index.clear()
	pass
