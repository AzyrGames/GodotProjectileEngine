extends Node2D
class_name ProjectileUpdater2D


var projectile_texture : Texture2D
var projectile_texture_visible : bool
var projectile_texture_modulate : Color
var projectile_animated_sprite : SpriteFrames
var projectile_animation_name : String
var use_animation : bool
var _animation_speed : float 
var _animation_frame_count : int 
var projectile_texture_draw_offset : Vector2

var _texture_rotate_direction : bool 

var projectile_template_2d : ProjectileTemplate2D


var projectile_instance_array : Array
var projectile_active_index : Array

var projectile_area_rid : RID
var projectile_pooling_index : int = 0
var projectile_max_pooling : int

var projectile_damage : int

var projectile_remove_index : Array = []

var _projectile_life_time_max : float
var _projectile_life_distance_max : float


var PS := PhysicsServer2D
var _projectile_instance : ProjectileInstance2D

var spawner_destroyed : bool = false

var _active_instances : Array[ProjectileInstance2D]
var _template_modules : Array[ProjectileTemplateModule]


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

func draw_projectile_texture() -> void:
	if !projectile_template_2d.texture_visible: return
	z_index = projectile_template_2d.texture_z_index
	projectile_texture = projectile_template_2d.texture
	projectile_texture_modulate = projectile_template_2d.texture_modulate
	projectile_texture_draw_offset = Vector2.ZERO - projectile_template_2d.texture.get_size() * 0.5
	use_animation = projectile_template_2d.use_animation
	
	for index : int in projectile_active_index:
		draw_set_transform_matrix(projectile_instance_array[index].transform)
		# if projectile_template_2d.use_animation:
		# 	draw_texture(projectile_template_2d.projectile_animated_sprite.get_frame_texture(
		# 		projectile_template_2d.projectile_animation_name, projectile_instance_array[index].animation_frame), 
		# 		projectile_template_2d.projectile_texture_draw_offset
		# 		)
		# else:
		draw_texture(projectile_texture, projectile_texture_draw_offset, projectile_texture_modulate)


func update_projectile_instances(delta: float) -> void:
	
	_texture_rotate_direction = projectile_template_2d.texture_rotate_direction

	_template_modules = projectile_template_2d.template_modules

	_projectile_life_time_max  = projectile_template_2d.life_time_max
	_projectile_life_distance_max  = projectile_template_2d.life_distance_max


	for index : int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]
		# Life Time & Distance
		_projectile_instance.life_time += delta

		if _projectile_instance.life_time >= _projectile_life_time_max:
			projectile_remove_index.append(index)
			continue

		_projectile_instance.life_distance += _projectile_instance.velocity.length()
		if _projectile_instance.life_distance >= _projectile_life_distance_max:
			projectile_remove_index.append(index)
			continue
		
		_projectile_instance.life_time_tick += 1


	if projectile_remove_index.size() > 0:
		for index : int in projectile_remove_index:
			projectile_active_index.erase(index)
			PS.area_set_shape_disabled(projectile_area_rid, index, true)
		projectile_remove_index.clear()

	_active_instances.clear()
	for index : int in projectile_active_index:
		_active_instances.append(projectile_instance_array[index])
	
	if _active_instances.size() <= 0: return


	for _template_module : ProjectileTemplateModule in _template_modules:
		_template_module.process_template(_active_instances)

	for _active_instance : ProjectileInstance2D in _active_instances:
		_active_instance.move_speed = _active_instance.base_move_speed * _active_instance.move_speed_modifier + _active_instance.move_speed_static
		_active_instance.velocity = _active_instance.move_speed * _active_instance.move_direction * delta
		_active_instance.global_position += _active_instance.velocity

		if _texture_rotate_direction:
			_active_instance.texture_rotation = _active_instance.move_direction.angle()

		_active_instance.transform = Transform2D(
			_active_instance.texture_rotation, 
			_active_instance.texture_scale, 
			_active_instance.texture_skew, 
			_active_instance.global_position
			)

		PS.area_set_shape_transform(projectile_area_rid, _active_instance.area_index, _active_instance.transform)
	
	for _trigger_condition in projectile_template_2d.trigger_conditions:
		_trigger_condition.check_trigger_condition(projectile_template_2d.trigger_name, _active_instances)
		pass


func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	for pattern_data : PatternComposerData in pattern_composer_pack:
		_projectile_instance = projectile_instance_array[projectile_pooling_index]
		_projectile_instance.base_move_direction = pattern_data.direction
		_projectile_instance.move_direction = _projectile_instance.base_move_direction

		_projectile_instance.global_position = pattern_data.position
		_projectile_instance.move_speed = _projectile_instance.base_move_speed
		_projectile_instance.move_speed_modifier = pattern_data.speed_mod

		if _projectile_instance.texture_rotate_direction:
			_projectile_instance.texture_rotation = pattern_data.direction.angle()

		_projectile_instance.life_time = 0.0
		_projectile_instance.life_time_tick = 0
		_projectile_instance.life_distance = 0.0

		_projectile_instance.transform = Transform2D(
			_projectile_instance.texture_rotation, 
			_projectile_instance.texture_scale, 
			_projectile_instance.texture_skew,
			_projectile_instance.global_position
			)
		

		PS.area_set_shape_transform(projectile_area_rid, projectile_pooling_index, _projectile_instance.transform)
		PS.area_set_shape_disabled(projectile_area_rid, projectile_pooling_index, false)
	
		projectile_instance_array[projectile_pooling_index] = _projectile_instance

		if projectile_template_2d.trigger_conditions.size() > 0:
			_projectile_instance.is_trigger = true
			_projectile_instance.trigger_dict = {}


		if projectile_pooling_index not in projectile_active_index:
			projectile_active_index.append(projectile_pooling_index)

		projectile_pooling_index += 1

		if projectile_pooling_index >= projectile_max_pooling:
			projectile_pooling_index = 0
	pass

#region Setup ProjectileUpdater

func setup_projectile_updater() -> void:
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
	projectile_max_pooling = projectile_template_2d.projectile_pooling_amount
	var _collision_rid : RID = 	projectile_template_2d.collision_shape.get_rid()

	for i in range(projectile_max_pooling):
		PS.area_add_shape(projectile_area_rid, _collision_rid, _transform, true)

		_projectile_instance = ProjectileInstance2D.new()

		_projectile_instance.area_rid = projectile_area_rid
		_projectile_instance.area_index = i
		
		_projectile_instance.base_texture_rotation = projectile_template_2d.texture_rotation

		_projectile_instance.texture_rotation = projectile_template_2d.texture_rotation
		
		_projectile_instance.base_texture_scale = projectile_template_2d.texture_scale
		_projectile_instance.texture_scale = projectile_template_2d.texture_scale

		_projectile_instance.base_move_speed = projectile_template_2d.move_speed

		# _projectile_instance.life_time_max = projectile_template_2d.life_time_max
		# _projectile_instance.life_distance_max = projectile_template_2d.life_distance_max



		projectile_instance_array.append(_projectile_instance)

func setup_area_callback(_projectile_area: RID) -> void:
	PS.area_set_monitor_callback(_projectile_area, _body_monitor_callback)
	PS.area_set_area_monitor_callback(_projectile_area, _area_monitor_callback)
	pass

func clear_projectile_updater() -> void:
	for instance : ProjectileInstance2D in projectile_instance_array:
		instance.queue_free()
		PS.area_clear_shapes(projectile_area_rid)


#endregion

func _body_monitor_callback(status: int, area_rid : RID, instance_id: int, body_shape_idx: int, self_shape_idx:int) -> void:
	if status == PS.AREA_BODY_ADDED:
		# print("Body entered")
		pass
	else:
		# print("Body existed")
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


func get_active_projectile_count() -> int:
	return _active_instances.size()
	pass

func clear_projectile() -> void:
	for _index in range(projectile_max_pooling):
		projectile_active_index.erase(_index)
		PS.area_set_shape_disabled(projectile_area_rid, _index, true)
	projectile_active_index.clear()
	pass
