extends Node2D
class_name BulletSpawner2D


@export var active : bool = true

var PS := PhysicsServer2D

var bullet_instance_array : Array[BulletInstance2D]
var bullet_area_shape_array : Array[RID]


var bullet_area : RID

@export var texture : Texture2D
@export var collision_shape : CircleShape2D

@export var bullet_composer : BulletComposer2D
@export var bullet_scheduler : BulletScheduler:
	set(value):
		if value:
			bullet_scheduler = value
			setup_bullet_scheduler()
		else:
			disconnect_bullet_scheduler()




@export_group("Collision")

@export_flags_2d_physics var collision_layer : int = 0:
	set(value):
		collision_layer = value
		PS.area_set_collision_layer(bullet_area, collision_layer)

@export_flags_2d_physics var collision_mask : int = 0:
	set(value):
		collision_mask = value
		PS.area_set_collision_layer(bullet_area, collision_mask)


var _draw_offset : Vector2

var bullet_count: int = 0

func _ready() -> void:
	setup_bullet_area()
	_draw_offset = texture.get_size() * 0.3


func _process(delta: float) -> void:
	queue_redraw()
	pass


var pattern_packs: Array

func _physics_process(delta: float) -> void:

	update_bullet(delta)
	pass


func _draw() -> void:
	for bullet_instance in bullet_instance_array:
		draw_set_transform_matrix(bullet_instance.transform)
		draw_texture(texture, Vector2.ZERO - Vector2(64, 64))
	

func spawn_bullet() -> void:
	pattern_packs = bullet_composer.create_pattern()
	for instance : Dictionary in pattern_packs:
		create_bullet_instance(instance)
	pass

var remove_array : Array

func update_bullet(delta: float) -> void:
	var index: int = 0

	for bullet_instance in bullet_instance_array:

		bullet_instance.life_time += delta
		if bullet_instance.life_time >= bullet_instance.max_life_time:
			PS.area_remove_shape(bullet_area, index)
			remove_array.append(bullet_instance)


		
		bullet_instance.velocity = bullet_instance.move_speed * bullet_instance.move_direction * delta
		bullet_instance.global_position += bullet_instance.velocity
		# bullet_instance.rotation += deg_to_rad(1)

		bullet_instance.transform = Transform2D(
			bullet_instance.rotation, 
			bullet_instance.scale, 
			bullet_instance.skew, 
			bullet_instance.global_position
			)



		PS.area_set_shape_transform(bullet_area, index, bullet_instance.transform)
		index += 1
	if remove_array.size() > 0:
		for bullet_instance : BulletInstance2D in remove_array:
			bullet_instance.queue_free()
			bullet_instance_array.erase(bullet_instance)
		remove_array.clear()

	pass


func setup_bullet_area() -> void:

	bullet_area = PS.area_create()
	PS.area_set_space(bullet_area, get_world_2d().space)
	PS.area_set_collision_layer(bullet_area, collision_layer)
	PS.area_set_collision_mask(bullet_area, collision_mask)
	PS.area_set_monitorable(bullet_area, true)
	PS.area_set_transform(bullet_area, Transform2D())

	PS.area_set_monitor_callback(bullet_area, _body_monitor_callback)
	PS.area_set_area_monitor_callback(bullet_area, _area_monitor_callback)

func update_bullet_instances() -> void:
	pass

func create_bullet_instance(instance: Dictionary) -> void:
	var _new_bullet_instance : BulletInstance2D = BulletInstance2D.new()

	_new_bullet_instance.move_direction = instance.direction
	_new_bullet_instance.global_position = instance.position
	if "speed_mod" in instance.keys():
		_new_bullet_instance.move_speed *= instance.speed_mod

	_new_bullet_instance.scale = Vector2.ONE * 0.4

	_new_bullet_instance.transform = Transform2D(
		_new_bullet_instance.rotation, 
		_new_bullet_instance.scale, 
		_new_bullet_instance.skew, 
		_new_bullet_instance.global_position
		)


	_new_bullet_instance.collision_shape_rid = PS.circle_shape_create()
	
	PS.shape_set_data(_new_bullet_instance.collision_shape_rid, 10)

	PS.area_add_shape(bullet_area, _new_bullet_instance.collision_shape_rid, _new_bullet_instance.transform)

	bullet_instance_array.append(_new_bullet_instance)
	bullet_area_shape_array.append(_new_bullet_instance.collision_shape_rid)

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
		# print("Area entered")
		pass
	else:
		# print("Area existed")
		pass





func setup_bullet_scheduler() -> void:
	bullet_scheduler.spawn_timed.connect(spawn_bullet)
	pass

func disconnect_bullet_scheduler() -> void:
	pass
