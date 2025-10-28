@icon("uid://b1j0h4n0fvbse")
extends Node2D
class_name ProjectileUpdater2D

var PS := PhysicsServer2D
var RS := RenderingServer

var projectile_template_2d: ProjectileTemplate2D
var projectile_custom_data: ProjectileCustomData

var projectile_max_pooling: int
var projectile_pooling_index: int = 0

var projectile_speed: float = 100.0
var projectile_texture: Texture2D
var projectile_texture_rotation: float
var projectile_texture_scale: Vector2
var projectile_texture_skew: float

var projectile_texture_visible: bool
var projectile_texture_modulate: Color
var projectile_texture_z_index: int
var projectile_reverse_z_index: bool = false

var projectile_collision_shape: Shape2D
var projectile_collision_layer: int = 0
var projectile_collision_mask: int = 0

var projectile_life_time_second_max: float
var projectile_life_distance_max: float

var projectile_area_rid: RID

var projectile_overlapping_areas: Dictionary
var projectile_overlapping_bodies: Dictionary

var projectile_instances: Array[ProjectileInstance2D]
var projectile_canvas_item_rids: Array[RID]
var projectile_active_indexes: Array[int]
var projectile_remove_indexes: Array[int]

var projectile_instance_callable: Callable

var _projectile_instance: ProjectileInstance2D


func _ready() -> void:
	setup_projectile_updater()


func _physics_process(delta: float) -> void:
	update_projectile_instances(delta)
	pass


#region Setup Projectile

func setup_projectile_updater() -> void:
	update_updater_variables()
	setup_projectile_area_rid()
	create_projectile_pool()

	projectile_template_2d.changed.connect(_on_projectile_template_changed)
	pass

func update_updater_variables() -> void:
	projectile_template_2d = projectile_template_2d as ProjectileTemplateObject2D
	projectile_speed = projectile_template_2d.speed

	projectile_texture = projectile_template_2d.texture
	projectile_texture_rotation = projectile_template_2d.texture_rotation
	projectile_texture_scale = projectile_template_2d.texture_scale
	projectile_texture_skew = projectile_template_2d.texture_skew

	projectile_texture_visible = projectile_template_2d.texture_visible
	projectile_texture_modulate = projectile_template_2d.texture_modulate
	projectile_texture_z_index = projectile_template_2d.texture_z_index
	projectile_reverse_z_index = projectile_template_2d.reverse_z_index

	projectile_collision_shape = projectile_template_2d.collision_shape
	projectile_collision_layer = projectile_template_2d.collision_layer
	projectile_collision_mask = projectile_template_2d.collision_mask

	projectile_life_time_second_max = projectile_template_2d.life_time_second_max
	projectile_life_distance_max = projectile_template_2d.life_distance_max
	pass


func _on_projectile_template_changed() -> void:
	update_updater_variables()
	if projectile_reverse_z_index != projectile_template_2d.reverse_z_index:
		if !projectile_reverse_z_index:
			for _index in projectile_max_pooling:
				RS.canvas_item_set_draw_index(
					projectile_instances[_index].canvas_item_rid, _index
					)
		else:
			for _index in projectile_max_pooling:
				RS.canvas_item_set_draw_index(
					projectile_instances[_index].canvas_item_rid, -_index
					)
	pass


func setup_projectile_area_rid() -> void:
	projectile_area_rid = PS.area_create()

	PS.area_set_space(projectile_area_rid, get_world_2d().space)
	PS.area_set_collision_layer(
		projectile_area_rid, projectile_template_2d.collision_layer
		)
	PS.area_set_collision_mask(
		projectile_area_rid, projectile_template_2d.collision_mask
		)
	PS.area_set_monitorable(projectile_area_rid, true)
	PS.area_set_transform(projectile_area_rid, Transform2D())
	setup_area_callback(projectile_area_rid)


	projectile_template_2d.projectile_area_rid = projectile_area_rid

func create_projectile_pool() -> void:
	var _transform_2d := Transform2D()
	var _collision_rid: RID
	var _canvas_item_id: RID

	if projectile_template_2d.collision_shape:
		_collision_rid = projectile_template_2d.collision_shape.get_rid()
	projectile_max_pooling = projectile_template_2d.projectile_pooling_amount

	for _index in range(projectile_max_pooling):
		if _collision_rid:
			PS.area_add_shape(projectile_area_rid, _collision_rid, _transform_2d, true)
		_projectile_instance = projectile_instance_callable.call()

		_projectile_instance.projectile_template_2d = projectile_template_2d
		_projectile_instance.projectile_updater_2d = self
	
		if projectile_custom_data:
			_projectile_instance.projectile_custom_data = projectile_custom_data

		_projectile_instance.area_rid = projectile_area_rid
		_projectile_instance.area_index = _index
		projectile_instances.append(_projectile_instance)

		## Create Canvas Item for projectile
		_canvas_item_id = RS.canvas_item_create()
		RS.canvas_item_set_parent(_canvas_item_id, get_canvas_item())
		RS.canvas_item_set_z_index(_canvas_item_id, projectile_texture_z_index)

		## Apply reverse z index
		if projectile_template_2d.reverse_z_index:
			RS.canvas_item_set_draw_index(_canvas_item_id, -_index)
		else:
			RS.canvas_item_set_draw_index(_canvas_item_id, _index)

		RS.canvas_item_set_z_as_relative_to_parent(_canvas_item_id, false)
		RS.canvas_item_set_modulate(_canvas_item_id, projectile_texture_modulate)
		RS.canvas_item_set_visible(_canvas_item_id, false)

		if projectile_texture:
			RS.canvas_item_add_texture_rect(
				_canvas_item_id,
				Rect2(-projectile_texture.get_size() / 2,
				projectile_texture.get_size()),
				projectile_texture
				)

		_projectile_instance.canvas_item_rid = _canvas_item_id
		projectile_canvas_item_rids.append(_canvas_item_id)


func setup_area_callback(_projectile_area: RID) -> void:
	PS.area_set_area_monitor_callback(_projectile_area, _area_monitor_callback)
	PS.area_set_monitor_callback(_projectile_area, _body_monitor_callback)
	pass


func _area_monitor_callback(
	status: int, area_rid: RID, 
	instance_id: int, area_shape_idx: int, self_shape_idx: int
	) -> void:
	var _instance_node: Area2D = instance_from_id(instance_id)
	if !is_instance_valid(_instance_node):
		return
	match status:
		PS.AREA_BODY_ADDED:
			ProjectileEngine.projectile_instance_area_shape_entered.emit(
				projectile_instances[self_shape_idx],
				area_rid, _instance_node, area_shape_idx,
				projectile_area_rid, self_shape_idx
			)

			ProjectileEngine.projectile_instance_area_entered.emit(
				projectile_instances[self_shape_idx], _instance_node
			)

			if projectile_overlapping_areas.has(self_shape_idx):
				projectile_overlapping_areas[self_shape_idx].append(_instance_node)
			else:
				projectile_overlapping_areas.get_or_add(
					self_shape_idx, [_instance_node]
					)

		PS.AREA_BODY_REMOVED:
			ProjectileEngine.projectile_instance_area_shape_exited.emit(
				projectile_instances[self_shape_idx],
				area_rid, _instance_node, area_shape_idx,
				projectile_area_rid, self_shape_idx
			)

			ProjectileEngine.projectile_instance_area_exited.emit(
				projectile_instances[self_shape_idx], _instance_node
			)

			if projectile_overlapping_areas.has(self_shape_idx):
				projectile_overlapping_areas[self_shape_idx].erase(_instance_node)
			
			if projectile_overlapping_areas[self_shape_idx].size() <= 0:
				projectile_overlapping_areas.erase(self_shape_idx)
	pass


func _body_monitor_callback(status: int, body_rid: RID, 
	instance_id: int, body_shape_idx: int, self_shape_idx: int
	) -> void:
	var _instance_node: Node = instance_from_id(instance_id)
	if !is_instance_valid(_instance_node):
		return
	match status:
		PS.AREA_BODY_ADDED:
			ProjectileEngine.projectile_instance_body_shape_entered.emit(
				projectile_instances[self_shape_idx],
				body_rid, instance_from_id(instance_id), body_shape_idx,
				projectile_area_rid, self_shape_idx
			)

			ProjectileEngine.projectile_instance_body_entered.emit(
				projectile_instances[self_shape_idx], instance_from_id(instance_id)
			)

			if projectile_overlapping_bodies.has(self_shape_idx):
				projectile_overlapping_bodies[self_shape_idx].append(_instance_node)
			else:
				projectile_overlapping_bodies.get_or_add(self_shape_idx, [_instance_node])

		PS.AREA_BODY_REMOVED:
			ProjectileEngine.projectile_instance_body_shape_exited.emit(
				projectile_instances[self_shape_idx],
				body_rid, instance_from_id(instance_id), body_shape_idx,
				projectile_area_rid, self_shape_idx
			)

			ProjectileEngine.projectile_instance_body_exited.emit(
				projectile_instances[self_shape_idx], instance_from_id(instance_id)
			)

			if projectile_overlapping_bodies.has(self_shape_idx):
				projectile_overlapping_bodies[self_shape_idx].erase(_instance_node)
			
			if projectile_overlapping_bodies[self_shape_idx].size() <= 0:
				projectile_overlapping_bodies.erase(self_shape_idx)
	pass


func process_projectile_collided(instance_index: int) -> void:
	if instance_index not in projectile_remove_indexes:
		projectile_remove_indexes.append(instance_index)
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

func clear_projectile_updater() -> void:
	for instance: ProjectileInstanceCustom2D in projectile_instances:
		instance.queue_free()
		PS.area_clear_shapes(projectile_area_rid)


func get_active_projectile_count() -> int:
	return projectile_active_indexes.size()
	pass


## Clear all ProjectileInstances in this ProjectileUpdater
func clear_projectiles() -> void:
	for _index in range(projectile_max_pooling):
		if projectile_active_indexes.has(_index):
			projectile_active_indexes.erase(_index)
		PS.area_set_shape_disabled(projectile_area_rid, _index, true)
	projectile_active_indexes.clear()
	pass


func hasprojectile_overlapping_areas(area_idx: int = -1) -> bool:
	return projectile_overlapping_areas.has(area_idx)


func getprojectile_overlapping_areas(area_idx: int = -1) -> Array:
	return projectile_overlapping_areas.get(area_idx)


func hasprojectile_overlapping_bodies(area_idx: int = -1) -> bool:
	return projectile_overlapping_bodies.has(area_idx)


func getprojectile_overlapping_bodies(area_idx: int = -1) -> Array:
	return projectile_overlapping_bodies.get(area_idx) as Array
