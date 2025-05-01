extends Node2D
class_name BulletUpdater2D


var bullet_texture : Texture2D
var bullet_animated_sprite : SpriteFrames
var bullet_animation_name : String
var use_animation : bool
var _animation_speed : float 
var _animation_frame_count : int 
var bullet_texture_draw_offset : Vector2

var _texture_rotate_direction : bool 

var bullet_template_2d : BulletTemplate2D


var bullet_instance_array : Array
var bullet_active_index : Array

var bullet_area_rid : RID
var bullet_pooling_index : int = 0
var bullet_max_pooling : int

var bullet_damage : int

var bullet_remove_index : Array = []

var _bullet_life_time_max : float
var _bullet_life_distance_max : float


var PS := PhysicsServer2D
var _bullet_instance : BulletInstance2D

var spawner_destroyed : bool = false

var _active_instances : Array[BulletInstance2D]
var _template_components : Array[BTCBase]


func _ready() -> void:
	setup_bullet_updater()


func _physics_process(delta: float) -> void:
	update_bullet_instances(delta)
	
	# Free Bullet Updater after spawner destroyed and no active bullet instances
	if spawner_destroyed and bullet_active_index.size() <= 0:
		clear_bullet_updater()
		queue_free()

	queue_redraw()
	pass


func _draw() -> void:
	draw_bullet_texture()

func draw_bullet_texture() -> void:
	z_index = bullet_template_2d.texture_z_index
	bullet_texture = bullet_template_2d.texture
	bullet_texture_draw_offset = Vector2.ZERO - bullet_template_2d.texture.get_size() * 0.5
	use_animation = bullet_template_2d.use_animation
	for index : int in bullet_active_index:
		draw_set_transform_matrix(bullet_instance_array[index].transform)
		# if bullet_template_2d.use_animation:
		# 	draw_texture(bullet_template_2d.bullet_animated_sprite.get_frame_texture(
		# 		bullet_template_2d.bullet_animation_name, bullet_instance_array[index].animation_frame), 
		# 		bullet_template_2d.bullet_texture_draw_offset
		# 		)
		# else:
		draw_texture(bullet_texture, bullet_texture_draw_offset)


func update_bullet_instances(delta: float) -> void:
	
	_texture_rotate_direction = bullet_template_2d.texture_rotate_direction

	_template_components = bullet_template_2d.template_components

	_bullet_life_time_max  = bullet_template_2d.life_time_max
	_bullet_life_distance_max  = bullet_template_2d.life_distance_max


	for index : int in bullet_active_index:
		_bullet_instance = bullet_instance_array[index]
		# Life Time & Distance
		_bullet_instance.life_time += delta

		if _bullet_instance.life_time >= _bullet_life_time_max:
			bullet_remove_index.append(index)
			continue

		_bullet_instance.life_distance += _bullet_instance.velocity.length()
		if _bullet_instance.life_distance >= _bullet_life_distance_max:
			bullet_remove_index.append(index)
			continue
		
		_bullet_instance.life_time_tick += 1


	if bullet_remove_index.size() > 0:
		for index : int in bullet_remove_index:
			bullet_active_index.erase(index)
			PS.area_set_shape_disabled(bullet_area_rid, index, true)
		bullet_remove_index.clear()

	_active_instances.clear()
	for index : int in bullet_active_index:
		_active_instances.append(bullet_instance_array[index])
	
	if _active_instances.size() <= 0: return


	for _template_component : BTCBase in _template_components:
		_template_component.process_template(_active_instances)

	for _active_instance : BulletInstance2D in _active_instances:
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

		PS.area_set_shape_transform(bullet_area_rid, _active_instance.area_index, _active_instance.transform)
	
	for _trigger_condition in bullet_template_2d.trigger_conditions:
		_trigger_condition.check_trigger_condition(_active_instances)
		pass


func spawn_bullet(pattern_packs: Array) -> void:
	for instance : Dictionary in pattern_packs:
		_bullet_instance = bullet_instance_array[bullet_pooling_index]
		_bullet_instance.base_move_direction = instance.direction
		_bullet_instance.move_direction =_bullet_instance.base_move_direction

		_bullet_instance.global_position = instance.position
		_bullet_instance.move_speed = _bullet_instance.base_move_speed
		if instance.has("speed_mod"):
			_bullet_instance.move_speed_modifier  = instance.speed_mod


		if _bullet_instance.texture_rotate_direction:
			_bullet_instance.texture_rotation = instance.direction.angle()

		_bullet_instance.life_time = 0.0
		_bullet_instance.life_time_tick = 0
		_bullet_instance.life_distance = 0.0

		_bullet_instance.transform = Transform2D(
			_bullet_instance.texture_rotation, 
			_bullet_instance.texture_scale, 
			_bullet_instance.texture_skew,
			_bullet_instance.global_position
			)
		

		PS.area_set_shape_transform(bullet_area_rid, bullet_pooling_index, _bullet_instance.transform)
		PS.area_set_shape_disabled(bullet_area_rid, bullet_pooling_index, false)
	
		bullet_instance_array[bullet_pooling_index] = _bullet_instance

		if bullet_template_2d.trigger_conditions.size() > 0:
			_bullet_instance.is_trigger = true
			_bullet_instance.trigger_dict = {}


		if bullet_pooling_index not in bullet_active_index:
			bullet_active_index.append(bullet_pooling_index)

		bullet_pooling_index += 1

		if bullet_pooling_index >= bullet_max_pooling:
			bullet_pooling_index = 0
	pass

#region Setup BulletUpdater

func setup_bullet_updater() -> void:
	setup_bullet_area_rid()
	create_bullet_pool()
	pass

func setup_bullet_area_rid() -> void:

	bullet_area_rid = PS.area_create()

	PS.area_set_space(bullet_area_rid, get_world_2d().space)
	PS.area_set_collision_layer(bullet_area_rid, bullet_template_2d.collision_layer)
	PS.area_set_collision_mask(bullet_area_rid, bullet_template_2d.collision_mask)
	PS.area_set_monitorable(bullet_area_rid, true)
	PS.area_set_transform(bullet_area_rid, Transform2D())

	bullet_template_2d.bullet_area_rid = bullet_area_rid

func create_bullet_pool() -> void:
	var _transform := Transform2D()
	bullet_max_pooling = bullet_template_2d.bullet_pooling_amount
	var _collision_rid : RID = 	bullet_template_2d.collision_shape.get_rid()

	for i in range(bullet_max_pooling):
		PS.area_add_shape(bullet_area_rid, _collision_rid, _transform, true)

		_bullet_instance = BulletInstance2D.new()

		_bullet_instance.area_index = i
		
		_bullet_instance.base_texture_rotation = bullet_template_2d.texture_rotation

		_bullet_instance.texture_rotation = bullet_template_2d.texture_rotation
		
		_bullet_instance.base_texture_scale = bullet_template_2d.texture_scale
		_bullet_instance.texture_scale = bullet_template_2d.texture_scale

		_bullet_instance.base_move_speed = bullet_template_2d.move_speed

		# _bullet_instance.life_time_max = bullet_template_2d.life_time_max
		# _bullet_instance.life_distance_max = bullet_template_2d.life_distance_max



		bullet_instance_array.append(_bullet_instance)

func setup_area_callback(_bullet_area: RID) -> void:
	PS.area_set_monitor_callback(_bullet_area, _body_monitor_callback)
	PS.area_set_area_monitor_callback(_bullet_area, _area_monitor_callback)
	pass

func clear_bullet_updater() -> void:
	for instance : BulletInstance2D in bullet_instance_array:
		instance.queue_free()
		PS.area_clear_shapes(bullet_area_rid)


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


func process_bullet_collided(instance_index: int) -> void:
	if instance_index not in bullet_remove_index:
		bullet_remove_index.append(instance_index)
	pass

# 	_homing_target_direction = _bullet_instance.global_position.direction_to(_homing_target_position)
# 	_bullet_instance.move_direction = _bullet_instance.move_direction.move_toward(_homing_target_direction, _homing_steer_speed * delta)



# Instance Transform

# if _bullet_instance.texture_rotation_speed != 0:
# 	_bullet_instance.texture_rotation += deg_to_rad(_bullet_instance.texture_rotation_speed)



# if _is_texture_scale_change:
# 	match _texture_scale_loop:
# 		0: #BulletTemplate2D.LoopType.ONCE_AND_KEEP:
# 			if _bullet_instance.life_time_tick < _texture_scale_max_tick:
# 				_texture_scale_sample = _bullet_instance.life_time_tick
# 			else:
# 				_texture_scale_sample = _texture_scale_max_tick - 1
# 		1: #BulletTemplate2D.LoopType.LOOP_FROM_START:
# 			_texture_scale_sample =_bullet_instance.life_time_tick % _texture_scale_max_tick
# 			pass
# 		2: #BulletTemplate2D.LoopType.PING_PONG:
# 			pass

# 	_texture_scale_sample_value = _texture_scale_cache[_texture_scale_sample]

# 	match _move_speed_math_type:
# 		0:
# 			_bullet_instance.texture_scale = _bullet_instance.base_texture_scale * _texture_scale_sample_value
# 			pass
# 		1:
# 			pass

# if bullet_remove_index.size() > 0:
# 	for index : int in bullet_remove_index:
# 		bullet_active_index.erase(index)
# 		PS.area_set_shape_disabled(bullet_area_rid, index, true)
#bullet_remove_index.clear()
