extends Node2D
class_name BulletUpdater2D


# var bullet_texture : Texture2D
# var bullet_animated_sprite : SpriteFrames
# var bullet_animation_name : String
# var use_animation : bool
# var bullet_texture_draw_offset : Vector2

var bullet_template_2d : BulletTemplate2D


var bullet_instance_array : Array
var bullet_active_index : Array

var bullet_area_rid : RID
var bullet_pooling_index : int = 0
var bullet_max_pooling : int

var bullet_damage : int

var bullet_remove_index : Array = []

var PS := PhysicsServer2D

var spawner_destroyed : bool = false
var _animation_speed : float 
var _animation_frame_count : int 


func _ready() -> void:
	setup_bullet_updater()
# 	setup_area_callback(bullet_area_rid)
# 	_animation_speed = (1.0 / bullet_animated_sprite.get_animation_speed(bullet_animation_name))
# 	_animation_frame_count = bullet_animated_sprite.get_frame_count(bullet_animation_name)
# 	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass

func _physics_process(delta: float) -> void:
	update_bullet_instances(delta)

	if spawner_destroyed and bullet_active_index.size() <= 0:
		clear_bullet_updater()
		queue_free()

	queue_redraw()
	pass


func _draw() -> void:
	draw_bullet_texture()

func draw_bullet_texture() -> void:
	for index : int in bullet_active_index:
		draw_set_transform_matrix(bullet_instance_array[index].transform)
		if bullet_template_2d.use_animation:
			draw_texture(bullet_template_2d.bullet_animated_sprite.get_frame_texture(
				bullet_template_2d.bullet_animation_name, bullet_instance_array[index].animation_frame), 
				bullet_template_2d.bullet_texture_draw_offset
				)
		else:
			draw_texture(bullet_template_2d.texture,Vector2.ZERO - bullet_template_2d.texture.get_size() * 0.5)



func update_bullet_instances(delta: float) -> void:
	var _bullet_instance : BulletInstance2D
	# print(bullet_active_index)
	var _speed_change_sample: float
	var _speed_change_sample_value: float
	var _move_speed_curve_max_tick := bullet_template_2d.move_speed_curve_max_tick
	var _move_speed_curve_cache := bullet_template_2d.move_speed_curve_cache
	var _move_speed_change_type := bullet_template_2d.move_speed_change_type
	var _is_move_speed_change := bullet_template_2d.is_move_speed_change
	# var _is_caching_move_speed_change := bullet_template_2d.is_caching_move_speed_change
	var _move_speed_change_loop := bullet_template_2d.move_speed_change_loop

	var _move_speed_math_max_tick := bullet_template_2d.move_speed_math_max_tick
	var _move_speed_math_cache := bullet_template_2d.move_speed_math_cache
	var _move_speed_math_type := bullet_template_2d.move_speed_math_type
	var _is_move_speed_change_math := bullet_template_2d.is_move_speed_change_math
	# var _is_caching_move_speed_change := bullet_template_2d.is_caching_move_speed_change
	var _move_speed_math_loop := bullet_template_2d.move_speed_math_loop


	var _is_move_direction_change := bullet_template_2d.is_move_direction_change
	var _move_direction_curve2d := bullet_template_2d.move_direction_curve2d
	var _move_direction_change_loop := bullet_template_2d.move_direction_change_loop
	var _move_direction_change_type := bullet_template_2d.move_direction_change_type

	var _move_direction_sample: float 
	var _baked_rotation : Transform2D

	var _is_homing : bool = bullet_template_2d.is_homing
	var _homing_target_type := bullet_template_2d.homing_target_type
	var _homing_target_position : Vector2 = Vector2.ZERO
	var _homing_target_direction : Vector2 = Vector2.ZERO
	var _homing_fixed_position := bullet_template_2d.homing_fixed_position
	# var _homing_node_position := bullet_template_2d.homing_node_path.global_position
	var _homing_steer_speed := bullet_template_2d.homing_steer_speed
	var _homing_target_nodes := get_tree().get_nodes_in_group("HomingTarget")
	print(BulletHell.bullet_homing_targets)
	var _homing_special_nodes := BulletHell.bullet_homing_targets[bullet_template_2d.homing_special_node_id]
	var _homing_distance_check : float = 0.0
	var _homing_distance_check_value : float = 0.0

	

	# var _homing_target_nodes := get_tree().get_nodes_in_group("HomingTarget")


	for index : int in bullet_active_index:
		_bullet_instance = bullet_instance_array[index]

		# Life Time & Distance
		_bullet_instance.life_time += delta
		_bullet_instance.life_time_tick += 1
		_bullet_instance.life_distance += _bullet_instance.velocity.length()
	
		if _bullet_instance.life_time >= _bullet_instance.life_time_max:
			if index not in bullet_remove_index:
				bullet_remove_index.append(index)
			continue

		# Animation
		if bullet_template_2d.use_animation:
			var _frame_time : float = _bullet_instance.animation_frame_tick * _animation_speed
			if _bullet_instance.life_time >= _frame_time:
				_bullet_instance.animation_frame += 1
				if _bullet_instance.animation_frame >= _animation_frame_count:
					_bullet_instance.animation_frame = 0
				_bullet_instance.animation_frame_tick += 1

		# Velocity

		if _is_move_speed_change:
			if bullet_template_2d.is_move_speed_change_curve:
				match _move_speed_change_loop:
					0: #BulletTemplate2D.LoopType.ONCE_AND_KEEP:
						if _bullet_instance.life_time_tick < _move_speed_curve_max_tick:
							_speed_change_sample = _bullet_instance.life_time_tick
						else:
							_speed_change_sample = _move_speed_curve_max_tick - 1
					1: #BulletTemplate2D.LoopType.LOOP_FROM_START:
						_speed_change_sample =_bullet_instance.life_time_tick % _move_speed_curve_max_tick
						pass
					2: #BulletTemplate2D.LoopType.PING_PONG:
						pass

				_speed_change_sample_value = _move_speed_curve_cache[_speed_change_sample]
				
				match _move_speed_change_type:
					0:
						_bullet_instance.move_speed = _bullet_instance.base_move_speed * _speed_change_sample_value
						pass
					1:
						_bullet_instance.move_speed = _speed_change_sample_value
						pass
			if _is_move_speed_change_math:
				match _move_speed_math_loop:
					0: #BulletTemplate2D.LoopType.ONCE_AND_KEEP:
						if _bullet_instance.life_time_tick < _move_speed_math_max_tick:
							_speed_change_sample = _bullet_instance.life_time_tick
						else:
							_speed_change_sample = _move_speed_math_max_tick - 1
					1: #BulletTemplate2D.LoopType.LOOP_FROM_START:
						_speed_change_sample =_bullet_instance.life_time_tick % _move_speed_math_max_tick
						pass
					2: #BulletTemplate2D.LoopType.PING_PONG:
						pass

				_speed_change_sample_value = _move_speed_math_cache[_speed_change_sample]
				
				match _move_speed_math_type:
					0:
						_bullet_instance.move_speed = _bullet_instance.base_move_speed * _speed_change_sample_value
						pass
					1:
						_bullet_instance.move_speed = _speed_change_sample_value
						pass
		if _is_move_direction_change:
			match _move_direction_change_loop:
				0: #BulletTemplate2D.LoopType.ONCE_AND_KEEP:
					_move_direction_sample = _bullet_instance.life_distance
					pass
				1: #BulletTemplate2D.LoopType.LOOP_FROM_START:
					_move_direction_sample = fmod(_bullet_instance.life_distance, _move_direction_curve2d.get_baked_length())
					pass
				2: #BulletTemplate2D.LoopType.PING_PONG:
					pass
	
			_baked_rotation = _move_direction_curve2d.sample_baked_with_rotation(_move_direction_sample)

			match _move_direction_change_type:
				0: #BulletTemplate2D.MoveDirectionChangeType.ROTATION:
					_bullet_instance.move_direction = _bullet_instance.base_move_direction.rotated(_baked_rotation.get_rotation())
					pass
				1: #BulletTemplate2D.MoveDirectionChangeType.HARD_DIRECTION:
					_bullet_instance.move_direction = Vector2.RIGHT.rotated(_baked_rotation.get_rotation())
					pass
				2:
					_bullet_instance.global_position = _baked_rotation.get_origin() - _bullet_instance.velocity
			pass


		if _is_homing:
			match _homing_target_type:
				0:
					_homing_target_position = _homing_fixed_position
				1:
					if _homing_target_nodes.size() == 0:
						_homing_target_position = Vector2.ZERO
					elif _homing_target_nodes.size() == 1:
						_homing_target_position = _homing_target_nodes[0].global_position
					else:
						_homing_distance_check = 9999999
						for _node in _homing_target_nodes:
							_homing_distance_check_value = _bullet_instance.global_position.distance_squared_to(_node.global_position)
							if _homing_distance_check_value < _homing_distance_check :
								_homing_distance_check = _homing_distance_check_value
								_homing_target_position = _node.global_position
				2:
					if _homing_special_nodes.size() == 0:
						_homing_target_position = Vector2.ZERO
					elif _homing_special_nodes.size() == 1:
						_homing_target_position = _homing_special_nodes[0].global_position
					else:
						_homing_distance_check = 9999999
						for _node in _homing_special_nodes:
							_homing_distance_check_value = _bullet_instance.global_position.distance_squared_to(_node.global_position)
							if _homing_distance_check_value < _homing_distance_check :
								_homing_distance_check = _homing_distance_check_value
								_homing_target_position = _node.global_position
				3:
					# _homing_target_position = _homing_node_position
					pass
					
			_homing_target_direction = _bullet_instance.global_position.direction_to(_homing_target_position)
			_bullet_instance.move_direction = _bullet_instance.move_direction.move_toward(_homing_target_direction, _homing_steer_speed * delta)

		# Todo: Test caching velocity
		_bullet_instance.velocity = _bullet_instance.move_speed * _bullet_instance.move_direction * delta
		_bullet_instance.global_position += _bullet_instance.velocity

		# Instance Transform

		if _bullet_instance.texture_rotation_speed != 0:
			_bullet_instance.texture_rotation += deg_to_rad(_bullet_instance.texture_rotation_speed)
		
		if bullet_template_2d.texture_rotate_direction:
			_bullet_instance.texture_rotation = _bullet_instance.move_direction.angle()

		_bullet_instance.transform = Transform2D(
			_bullet_instance.texture_rotation, 
			_bullet_instance.scale, 
			_bullet_instance.skew, 
			_bullet_instance.global_position
			)

		PS.area_set_shape_transform(bullet_area_rid, index, _bullet_instance.transform)
		
		bullet_instance_array[index] = _bullet_instance

	if bullet_remove_index.size() > 0:
		for index : int in bullet_remove_index:
			bullet_active_index.erase(index)
			PS.area_set_shape_disabled(bullet_area_rid, index, true)
		bullet_remove_index.clear()


func spawn_bullet(pattern_packs: Array) -> void:
	var _bullet_instance : BulletInstance2D

	for instance : Dictionary in pattern_packs:
		_bullet_instance = bullet_instance_array[bullet_pooling_index]
		_bullet_instance.base_move_direction = instance.direction
		_bullet_instance.move_direction =_bullet_instance.base_move_direction

		_bullet_instance.global_position = instance.position
		_bullet_instance.move_speed = _bullet_instance.base_move_speed
		if instance.has("speed_mod"):
			_bullet_instance.move_speed  *= instance.speed_mod


		if _bullet_instance.texture_rotate_direction:
			_bullet_instance.texture_rotation = instance.direction.angle()

		_bullet_instance.scale = Vector2.ONE

		_bullet_instance.life_time = 0.0
		_bullet_instance.life_time_tick = 0
		_bullet_instance.life_distance = 0.0


		_bullet_instance.transform = Transform2D(
			_bullet_instance.texture_rotation, 
			_bullet_instance.scale, 
			_bullet_instance.skew, 
			_bullet_instance.global_position
			)
		

		PS.area_set_shape_transform(bullet_area_rid, bullet_pooling_index, _bullet_instance.transform)
		PS.area_set_shape_disabled(bullet_area_rid, bullet_pooling_index, false)
	
		bullet_instance_array[bullet_pooling_index] = _bullet_instance

		if bullet_pooling_index not in bullet_active_index:
			bullet_active_index.append(bullet_pooling_index)

		bullet_pooling_index += 1

		if bullet_pooling_index >= bullet_max_pooling:
			bullet_pooling_index = 0
	pass

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
	var _bullet_instance : BulletInstance2D
	bullet_template_2d.caching_move_speed_change()

	for i in range(bullet_max_pooling):
		PS.area_add_shape(bullet_area_rid, _collision_rid, _transform, true)

		_bullet_instance = BulletInstance2D.new()
		_bullet_instance.texture_rotate_direction = bullet_template_2d.texture_rotate_direction
		_bullet_instance.texture_rotation_speed = bullet_template_2d.texture_rotation_speed

		_bullet_instance.base_move_speed = bullet_template_2d.move_speed
		_bullet_instance.life_time_max = bullet_template_2d.life_time_max
		
		bullet_instance_array.append(_bullet_instance)

func clear_bullet_updater() -> void:
	for instance : BulletInstance2D in bullet_instance_array:
		instance.queue_free()
		PS.area_clear_shapes(bullet_area_rid)


func setup_area_callback(_bullet_area: RID) -> void:
	PS.area_set_monitor_callback(_bullet_area, _body_monitor_callback)
	PS.area_set_area_monitor_callback(_bullet_area, _area_monitor_callback)
	pass



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
