@icon("uid://b1j0h4n0fvbse")
extends Node2D
class_name ProjectileNodeManager2D

var projectile_template_2d : ProjectileTemplate2D

var projectile_pooling_index : int = 0
var projectile_max_pooling : int

var projectile_node_array : Array[Projectile2D]
var active_nodes : Array[Projectile2D]

var projectile_node_2d_packedscene : PackedScene

var _projectile_node_2d : Projectile2D

var _is_valid_projectile_node_2d : bool = false


func setup_projectile_manager() -> void:
	if !is_instance_valid(projectile_template_2d):
		return
	projectile_template_2d = projectile_template_2d as ProjectileTemplateNode2D
	projectile_node_2d_packedscene = _load_projectile_node(projectile_template_2d.projectile_2d_path)

	if !is_instance_valid(projectile_node_2d_packedscene):
		print_debug(projectile_node_2d_packedscene, " is not valid!")
		_is_valid_projectile_node_2d = false
		return
	
	var _instantiate_node = projectile_node_2d_packedscene.instantiate() 
	if !_instantiate_node is Projectile2D:
		print_debug(_instantiate_node, " is not Projectile2D")
		_is_valid_projectile_node_2d = false
		return

	_is_valid_projectile_node_2d = true
	create_projectile_pool()
	pass


func create_projectile_pool() -> void:
	projectile_max_pooling = projectile_template_2d.projectile_pooling_amount
	projectile_node_array.clear()
	if projectile_template_2d.projectile_pooling_amount <= 0:
		projectile_max_pooling = -1
		return
	for _index in projectile_max_pooling:
		_projectile_node_2d = projectile_node_2d_packedscene.instantiate()
		_projectile_node_2d.projectile_template_2d = projectile_template_2d
		_projectile_node_2d.projectile_node_manager = self
		_projectile_node_2d.projectile_node_index = _index
		_projectile_node_2d.active = false
		_projectile_node_2d.visible = false
		_projectile_node_2d.monitoring = false
		_projectile_node_2d.monitorable = false
	
		add_child(_projectile_node_2d, true)
		_projectile_node_2d.set_owner(self)
		projectile_node_array.append(_projectile_node_2d)
	pass


func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	if !_is_valid_projectile_node_2d:
		push_warning("ProjectileNode2D is not vailid")
		return
	if projectile_max_pooling > 0:
		for _pattern_composer_data : PatternComposerData in pattern_composer_pack:
			_projectile_node_2d = projectile_node_array[projectile_pooling_index]
			_projectile_node_2d.projectile_template_2d = projectile_template_2d
			_projectile_node_2d.active = true
			_projectile_node_2d.visible = true
			_projectile_node_2d.monitoring = true
			_projectile_node_2d.monitorable = true
			_projectile_node_2d.life_time_second = 0.0
			_projectile_node_2d.life_distance = 0.0

			_projectile_node_2d.apply_pattern_composer_data(_pattern_composer_data)
			_projectile_node_2d.setup_projectile_2d()

			projectile_pooling_index += 1
			if projectile_pooling_index >= projectile_max_pooling:
				projectile_pooling_index = 0
	
			active_nodes.append(_projectile_node_2d)
			pass
	else:
		for _pattern_composer_data : PatternComposerData in pattern_composer_pack:
			_projectile_node_2d = null
			_projectile_node_2d = projectile_node_2d_packedscene.instantiate()
			_projectile_node_2d.projectile_template_2d = projectile_template_2d
			_projectile_node_2d.projectile_node_manager = self
			_projectile_node_2d.projectile_node_index = -1
			_projectile_node_2d.apply_pattern_composer_data(_pattern_composer_data)
			_projectile_node_2d.active = true
			add_child(_projectile_node_2d, true)
			_projectile_node_2d.set_owner(self)
			active_nodes.append(_projectile_node_2d)
			pass


## Clear all ProjectileNode2D in this ProjetileNodeManager
func clear_projectiles() -> void:
	for child in get_children():
		if child is not Projectile2D:
			continue
		child.queue_free_projectile()
		pass
	pass


func get_active_projectile_count() -> int:
	return active_nodes.size()


func _load_projectile_node(_file_path: String) -> PackedScene:
	if _file_path == "":
		print_debug("ProjectileTemplateNode file path is null")
		return null
	var _packed_projectile_node : PackedScene = load(_file_path)
	if !_packed_projectile_node:
		print_debug(_file_path ," is not a valid file path: ")
		return null
	return _packed_projectile_node
	pass
