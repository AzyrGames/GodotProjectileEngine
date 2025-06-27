extends Node2D
class_name ProjectileUpdaterAdvanced2D

var projectile_template_2d : ProjectileTemplateAdvanced2D

var projectile_damage: float = 1.0
var projectile_speed : float = 100:
	set(value):
		projectile_speed = value
var projectile_velocity : Vector2 = Vector2.ZERO

var projectile_life_time_max : float = 10.0
var projectile_life_distance_max : float = 300.0

var projectile_speed_acceleration : float = 0.0
var projectile_speed_max : float = 0.0

var projectile_is_use_homing : bool = false
var projectile_homing_target_group : String
var projetile_max_homing_distance : float 
var projectile_steer_speed : float
var projectile_homing_strength : float
var _homing_group_nodes : Array[Node]
var _homing_nearest_target : Node2D
var _homing_nearest_distance : float
var _homing_distance : float
var _homing_target_position : Vector2
var _homing_distance_to_target : float
var _homing_desired_direction : Vector2
var _homing_new_direction : Vector2
var _homing_final_direction : Vector2

var projectile_rotation_speed : float
var projectile_rotation_follow_direction : bool
var projectile_direction_follow_rotation : bool

var projectile_scale_acceleration : float
var projectile_scale_max : Vector2

var projectile_is_use_trigger : bool
var projectile_trigger_name : StringName
var projectile_trigger_amount : int
var projectile_trigger_life_time : float
var projectile_trigger_life_distance : float

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

var _active_instances : Array[ProjectileInstanceAdvanced2D]
var _projectile_instance : ProjectileInstanceAdvanced2D


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

	projectile_template_2d.projectile_area_rid = projectile_area_rid

func create_projectile_pool() -> void:
	var _transform := Transform2D()
	var _collision_rid : RID = 	projectile_template_2d.collision_shape.get_rid()

	projectile_max_pooling = projectile_template_2d.projectile_pooling_amount

	for _index in range(projectile_max_pooling):
		PS.area_add_shape(projectile_area_rid, _collision_rid, _transform, true)

		_projectile_instance = ProjectileInstanceAdvanced2D.new()

		_projectile_instance.area_rid = projectile_area_rid
		_projectile_instance.area_index = _index


		projectile_instance_array.append(_projectile_instance)

func init_updater_variable() -> void:
	projectile_damage = projectile_template_2d.damage
	projectile_speed = projectile_template_2d.speed
	projectile_speed_acceleration = projectile_template_2d.speed_acceleration
	projectile_speed_max = projectile_template_2d.speed_max

	projectile_life_time_max  = projectile_template_2d.life_time_max
	projectile_life_distance_max  = projectile_template_2d.life_distance_max
	projectile_direction_follow_rotation = projectile_template_2d.rotation_follow_direction
	pass

func setup_area_callback(_projectile_area: RID) -> void:
	PS.area_set_monitor_callback(_projectile_area, _body_monitor_callback)
	PS.area_set_area_monitor_callback(_projectile_area, _area_monitor_callback)
	pass

func _body_monitor_callback(status: int, area_rid : RID, instance_id: int, body_shape_idx: int, self_shape_idx:int) -> void:
	if status == PS.AREA_BODY_ADDED:
		pass
	else:
		pass


func _area_monitor_callback(status: int, area_rid : RID, instance_id: int, area_shape_idx: int, self_shape_idx:int) -> void:
	if status == PS.AREA_BODY_ADDED:
		pass
	else:
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

		_projectile_instance.base_direction = pattern_data.direction
		

		if projectile_template_2d.direction_follow_rotation:
			_projectile_instance.direction = _projectile_instance.base_direction.rotated(pattern_data.rotation)
		else:
			_projectile_instance.direction = pattern_data.direction

		if projectile_template_2d.rotation_follow_direction:
			_projectile_instance.texture_rotation = pattern_data.direction.angle()
		else:
			_projectile_instance.texture_rotation = pattern_data.rotation

		_projectile_instance.scale = projectile_template_2d.texture_scale

		_projectile_instance.life_time = 0.0
		_projectile_instance.life_distance = 0.0

		_projectile_instance.transform = Transform2D(
			_projectile_instance.texture_rotation, 
			projectile_template_2d.texture_scale,
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

func update_projectile_instances(delta: float) -> void:
	projectile_damage = projectile_template_2d.damage

	projectile_speed = projectile_template_2d.speed
	projectile_speed_acceleration = projectile_template_2d.speed_acceleration
	projectile_speed_max = projectile_template_2d.speed_max
	projectile_is_use_homing = projectile_template_2d.is_use_homing

	if projectile_is_use_homing:
		projectile_homing_target_group = projectile_template_2d.target_group
		projetile_max_homing_distance = projectile_template_2d.max_homing_distance
		projectile_steer_speed = projectile_template_2d.steer_speed
		projectile_homing_strength = projectile_template_2d.homing_strength

	projectile_rotation_speed = projectile_template_2d.rotation_speed
	projectile_rotation_follow_direction = projectile_template_2d.rotation_follow_direction
	projectile_direction_follow_rotation = projectile_template_2d.direction_follow_rotation

	projectile_scale_acceleration = projectile_template_2d.scale_acceleration
	projectile_scale_max = Vector2.ONE * projectile_template_2d.scale_max


	projectile_life_time_max  = projectile_template_2d.life_time_max
	projectile_life_distance_max  = projectile_template_2d.life_distance_max
	
	projectile_is_use_trigger = projectile_template_2d.is_use_trigger
	projectile_trigger_name = projectile_template_2d.trigger_name
	projectile_trigger_amount = projectile_template_2d.trigger_amount
	projectile_trigger_life_time = projectile_template_2d.trigger_life_time
	projectile_trigger_life_distance = projectile_template_2d.trigger_life_distance


	# Check for projectile destroy condition
	for index : int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]

		# Life Time & Distance
		if projectile_life_time_max >= 0:
			_projectile_instance.life_time += delta
			if _projectile_instance.life_time >= projectile_life_time_max:
				projectile_remove_index.append(index)
				continue

		if projectile_life_distance_max >= 0:
			_projectile_instance.life_distance += _projectile_instance.velocity.length()
			if _projectile_instance.life_distance >= projectile_life_distance_max:
				projectile_remove_index.append(index)
				continue

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
	for _active_instance : ProjectileInstanceAdvanced2D in _active_instances:
		
		if projectile_is_use_trigger:
			if _active_instance.trigger_count <= projectile_trigger_amount:
				if projectile_trigger_life_time > 0:
					if _active_instance.life_time >= projectile_trigger_life_time * _active_instance.trigger_count:
						ProjectileEngine.projectile_instance_triggered.emit(projectile_trigger_name, _active_instance)
						_active_instance.trigger_count += 1
				if projectile_trigger_life_distance > 0:
					if _active_instance.life_distance >= projectile_trigger_life_distance * _active_instance.trigger_count:
						ProjectileEngine.projectile_instance_triggered.emit(projectile_trigger_name, _active_instance)
						_active_instance.trigger_count += 1

		if projectile_is_use_homing:
			_homing_group_nodes = get_tree().get_nodes_in_group(projectile_homing_target_group)
			if !_homing_group_nodes.is_empty():
				_homing_nearest_target = null
				_homing_nearest_distance = INF
				
				for node in _homing_group_nodes:
					if node is Node2D and is_instance_valid(node):
						_homing_distance = _active_instance.global_position.distance_to(node.global_position)
						if _homing_distance < _homing_nearest_distance:
							_homing_nearest_distance = _homing_distance
							_homing_nearest_target = node
				
					if _homing_nearest_target:
						_homing_target_position = _homing_nearest_target.global_position
					
					# Calculate distance to target
					_homing_distance_to_target = _active_instance.global_position.distance_to(_homing_target_position)
					
					# Check distance constraint
					if projetile_max_homing_distance <= 0.0 or _homing_distance_to_target <= projetile_max_homing_distance:
						# Calculate desired direction toward target
						_homing_desired_direction = _active_instance.global_position.direction_to(_homing_target_position)
						
						# Gradually steer toward target
						_homing_new_direction = _active_instance.direction.move_toward(_homing_desired_direction, projectile_steer_speed * delta)
						_homing_final_direction = _homing_new_direction.normalized() * projectile_homing_strength + _active_instance.direction * (1.0 - projectile_homing_strength)
						
						_active_instance.direction = _homing_final_direction.normalized()

			if projectile_speed_acceleration == 0:
				_active_instance.velocity = _active_instance.speed * _active_instance.direction * delta

		if projectile_rotation_follow_direction:
			_active_instance.texture_rotation = _active_instance.direction.angle()
		
		if projectile_rotation_speed != 0:
			_active_instance.texture_rotation += projectile_rotation_speed * delta

		if projectile_direction_follow_rotation:
			_active_instance.direction = Vector2.RIGHT.rotated(_active_instance.texture_rotation)
			_active_instance.velocity = _active_instance.speed * _active_instance.direction * delta

		if projectile_speed_acceleration != 0:
			if _active_instance.speed < projectile_speed_max:
				_active_instance.speed = move_toward(
					_active_instance.speed, projectile_speed_max, projectile_speed_acceleration * delta
					)

			_active_instance.velocity = _active_instance.speed * _active_instance.direction * delta
	

		if projectile_scale_acceleration != 0 and _active_instance.scale < projectile_scale_max:
			_active_instance.scale = _active_instance.scale.move_toward(projectile_scale_max, projectile_scale_acceleration * delta)
			
		_active_instance.global_position += _active_instance.velocity
	
		_active_instance.transform = Transform2D(
			_active_instance.texture_rotation,
			_active_instance.scale,
			0.0,
			_active_instance.global_position
			)


		PS.area_set_shape_transform(projectile_area_rid, _active_instance.area_index, _active_instance.transform)


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
	for instance : ProjectileInstanceAdvanced2D in projectile_instance_array:
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
