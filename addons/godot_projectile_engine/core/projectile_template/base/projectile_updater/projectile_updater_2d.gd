@icon("uid://b1j0h4n0fvbse")
extends Node2D
class_name ProjectileUpdater2D

var projectile_template_2d : ProjectileTemplate2D

var projectile_speed : float = 100.0

var projectile_texture : Texture2D
var projectile_texture_rotation : float
var projectile_texture_visible : bool
var projectile_texture_modulate : Color

var projectile_texture_draw_offset : Vector2

var PS := PhysicsServer2D
var projectile_area_rid : RID
var projectile_collision_shape : Shape2D
var projectile_collision_layer : int = 0
var projectile_collision_mask : int = 0

var projectile_pooling_index : int = 0
var projectile_max_pooling : int

var projectile_instance_array : Array[ProjectileInstance2D]
var projectile_active_index : Array[int]
var projectile_remove_index : Array[int]

var spawner_destroyed : bool = false

var custom_data : Array[Variant]

var _active_projectile_instances : Array[ProjectileInstance2D]

var _projectile_instance : ProjectileInstance2D
var _new_projectile_instance : Callable

var _overlapping_areas : Dictionary
var _overlapping_bodies : Dictionary



func _ready() -> void:
	setup_projectile_updater()


func _physics_process(delta: float) -> void:
	update_projectile_instances(delta)
	# Free Projectile Updater when spawner destroyed and there are no active projectile instances
	# if spawner_destroyed and projectile_active_index.size() <= 0:
	# 	clear_projectile_updater()
	# 	# queue_free()

	queue_redraw()
	pass


func _draw() -> void:
	if !projectile_template_2d.texture: return
	if !projectile_template_2d.texture_visible: return
	draw_projectile_texture()


#region Setup Projectile

func setup_projectile_updater() -> void:
	projectile_collision_layer = projectile_template_2d.collision_layer
	projectile_collision_mask = projectile_template_2d.collision_mask
	projectile_collision_shape = projectile_template_2d.collision_shape
	init_updater_variable()
	setup_projectile_area_rid()
	create_projectile_pool()
	pass

func init_updater_variable() -> void:
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
	var _collision_rid : RID 
	if projectile_template_2d.collision_shape:
		_collision_rid = projectile_template_2d.collision_shape.get_rid()

	projectile_max_pooling = projectile_template_2d.projectile_pooling_amount
	for _index in range(projectile_max_pooling):
		if _collision_rid:
			PS.area_add_shape(projectile_area_rid, _collision_rid, _transform, true)
		_projectile_instance = _new_projectile_instance.call()
		_projectile_instance.projectile_updater = self
		_projectile_instance.custom_data = custom_data
		_projectile_instance.area_rid = projectile_area_rid
		_projectile_instance.area_index = _index

		projectile_instance_array.append(_projectile_instance)

func setup_area_callback(_projectile_area: RID) -> void:
	PS.area_set_area_monitor_callback(_projectile_area, _area_monitor_callback)
	PS.area_set_monitor_callback(_projectile_area, _body_monitor_callback)
	pass

func _area_monitor_callback(status: int, area_rid : RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	var _instance_node : Area2D = instance_from_id(instance_id)
	if !is_instance_valid(_instance_node):
		return
	match status:
		PS.AREA_BODY_ADDED:
			ProjectileEngine.projectile_instance_area_shape_entered.emit(
				projectile_instance_array[self_shape_idx],
				area_rid, _instance_node, area_shape_idx,
				projectile_area_rid, self_shape_idx
			)

			ProjectileEngine.projectile_instance_area_entered.emit(
				projectile_instance_array[self_shape_idx], _instance_node
			)

			if _overlapping_areas.has(self_shape_idx):
				_overlapping_areas[self_shape_idx].append(_instance_node)
			else:
				_overlapping_areas.get_or_add(self_shape_idx, [_instance_node])

		PS.AREA_BODY_REMOVED:
			ProjectileEngine.projectile_instance_area_shape_exited.emit(
				projectile_instance_array[self_shape_idx],
				area_rid, _instance_node, area_shape_idx,
				projectile_area_rid, self_shape_idx
			)

			ProjectileEngine.projectile_instance_area_exited.emit(
				projectile_instance_array[self_shape_idx], _instance_node
			)

			if _overlapping_areas.has(self_shape_idx):
				_overlapping_areas[self_shape_idx].erase(_instance_node)
			
			if _overlapping_areas[self_shape_idx].size() <= 0:
				_overlapping_areas.erase(self_shape_idx)
	pass

func _body_monitor_callback(status: int, body_rid : RID, instance_id: int, body_shape_idx: int, self_shape_idx: int) -> void:
	var _instance_node : Node = instance_from_id(instance_id)
	if !is_instance_valid(_instance_node):
		return
	match status:
		PS.AREA_BODY_ADDED:
			ProjectileEngine.projectile_instance_body_shape_entered.emit(
				projectile_instance_array[self_shape_idx],
				body_rid, instance_from_id(instance_id), body_shape_idx,
				projectile_area_rid, self_shape_idx
			)

			ProjectileEngine.projectile_instance_body_entered.emit(
				projectile_instance_array[self_shape_idx], instance_from_id(instance_id)
			)
			if _overlapping_bodies.has(self_shape_idx):
				_overlapping_bodies[self_shape_idx].append(_instance_node)
			else:
				_overlapping_bodies.get_or_add(self_shape_idx, [_instance_node])

		PS.AREA_BODY_REMOVED:
			ProjectileEngine.projectile_instance_body_shape_exited.emit(
				projectile_instance_array[self_shape_idx],
				body_rid, instance_from_id(instance_id), body_shape_idx,
				projectile_area_rid, self_shape_idx
			)

			ProjectileEngine.projectile_instance_body_exited.emit(
				projectile_instance_array[self_shape_idx], instance_from_id(instance_id)
			)

			if _overlapping_bodies.has(self_shape_idx):
				_overlapping_bodies[self_shape_idx].erase(_instance_node)
			
			if _overlapping_bodies[self_shape_idx].size() <= 0:
				_overlapping_bodies.erase(self_shape_idx)
	pass




func process_projectile_collided(instance_index: int) -> void:
	if instance_index not in projectile_remove_index:
		projectile_remove_index.append(instance_index)
	pass

#endregion


#region Spawn Projectile 

func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	pass

#endregion


#region Update Projectile

func update_projectile_instances(delta: float) -> void:
	pass

#endregion


#region Draw Projectile

func draw_projectile_texture() -> void:
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
	return _active_projectile_instances.size()
	pass


## Clear all ProjectileInstances in this ProjectileUpdater
func clear_projectiles() -> void:
	for _index in range(projectile_max_pooling):
		if projectile_active_index.has(_index):
			projectile_active_index.erase(_index)
		PS.area_set_shape_disabled(projectile_area_rid, _index, true)
	projectile_active_index.clear()
	pass


func has_overlapping_areas(area_idx: int = -1) -> bool:
	return _overlapping_areas.has(area_idx)


func get_overlapping_areas(area_idx: int = -1) -> Array:
	return _overlapping_areas.get(area_idx)


func has_overlapping_bodies(area_idx: int = -1) -> bool:
	return _overlapping_bodies.has(area_idx)


func get_overlapping_bodies(area_idx: int = -1) -> Array:
	return _overlapping_bodies.get(area_idx) as Array
