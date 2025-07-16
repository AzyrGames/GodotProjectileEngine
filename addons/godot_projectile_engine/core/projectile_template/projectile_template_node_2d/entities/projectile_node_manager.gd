extends Node2D
class_name ProjectileNodeManager2D

var projectile_template_2d : ProjectileTemplate2D

var projectile_pooling_index : int = 0
var projectile_max_pooling : int

var projectile_node_array : Array[Projectile2D]
var active_nodes : Array[Projectile2D]

var projectile_node_2d_packedscene : PackedScene

var _projectile_node_2d : Projectile2D



func setup_projectile_manager() -> void:
	if !is_instance_valid(projectile_template_2d):
		return
	projectile_template_2d = projectile_template_2d as ProjectileTemplateNode2D
	projectile_node_2d_packedscene = load(projectile_template_2d.projectile_2d_path)
	create_projectile_pool()
	pass

func create_projectile_pool() -> void:
	projectile_max_pooling = projectile_template_2d.projectile_pooling_amount
	if projectile_template_2d.projectile_pooling_amount <= 0:
		return
	projectile_node_array.clear()
	for _index in projectile_max_pooling:
		_projectile_node_2d = projectile_node_2d_packedscene.instantiate()
		_projectile_node_2d.projectile_node_manager = self
		_projectile_node_2d.projectile_node_index = _index
		_projectile_node_2d.active = false
		_projectile_node_2d.visible = false

		add_child(_projectile_node_2d, true)
		_projectile_node_2d.set_owner(self)
		projectile_node_array.append(_projectile_node_2d)
	pass


func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	if projectile_max_pooling > 0:
		for _pattern_composer_data : PatternComposerData in pattern_composer_pack:
			_projectile_node_2d = projectile_node_array[projectile_pooling_index]
			_projectile_node_2d.active = true
			_projectile_node_2d.visible = true
			_projectile_node_2d.apply_pattern_composer_data(_pattern_composer_data)
			_projectile_node_2d
			projectile_pooling_index += 1
			if projectile_pooling_index >= projectile_max_pooling:
				projectile_pooling_index = 0
			pass
	else:
		for _pattern_composer_data : PatternComposerData in pattern_composer_pack:
			_projectile_node_2d = projectile_node_2d_packedscene.instantiate()
			_projectile_node_2d.projectile_node_index = -1
			_projectile_node_2d.active = true
			_projectile_node_2d.visible = true
			_projectile_node_2d.apply_pattern_composer_data(_pattern_composer_data)
			add_child(_projectile_node_2d)
			