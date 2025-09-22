@icon("uid://dhtd7y4cpej7o")
extends Node2D
class_name ProjectileSpawner2D

signal spawn_timed
signal scheduler_completed
signal projectile_spawned(_projectile_template: ProjectileTemplate2D)

@export var active : bool = true:
	set(value):
		active = value
		if active:
			activate_projectile_spawner()
		else:
			deactive_projectile_spanwer()

@export var projectile_composer_name : String
@export var projectile_template_2d : ProjectileTemplate2D
@export var timing_scheduler : TimingScheduler
@export var use_spawn_markers : bool = false
@export var audio_stream: AudioStreamPlayer
@export var audio_stream_2d: AudioStreamPlayer2D


var projectile_area : RID

var projectile_spawn_markers : Array[ProjectileSpawnMarker2D]

var projectile_composer : PatternComposer2D
var pattern_composer_context : PatternComposerContext
var pattern_composer_pack: Array

var projectile_updater_2d : ProjectileUpdater2D
var projectile_node_manager_2d : ProjectileNodeManager2D
var projectile_count: int = 0

var _projectile_2d_instance : Projectile2D
var _pattern_composer_pack : Array


func _ready() -> void:
	setup_spawn_marker()
	if active:
		activate_projectile_spawner()
	pass


func activate_projectile_spawner() -> void:
	setup_projectile_spawner()
	connect_audio()
	connect_timing_scheduler()
	pass


func setup_projectile_spawner() -> void:
	projectile_composer = ProjectileEngine.projectile_composer_nodes.get(projectile_composer_name)

	if !projectile_composer:
		print_debug(projectile_composer_name + " PatternComposer ID is not valid")
		return
	if typeof(projectile_template_2d) != TYPE_OBJECT:
		return
	match projectile_template_2d.get_script():
		ProjectileTemplateSimple2D:
			if !is_instance_valid(
				ProjectileEngine.projectile_updater_2d_nodes.get(
					projectile_template_2d.projectile_area_rid
				)
			):
				create_projectile_updater_simple_2d()
			projectile_updater_2d = ProjectileEngine.projectile_updater_2d_nodes.get(
				projectile_template_2d.projectile_area_rid
			)

		ProjectileTemplateAdvanced2D:
			if !is_instance_valid(
				ProjectileEngine.projectile_updater_2d_nodes.get(
					projectile_template_2d.projectile_area_rid
				)
			):
				create_projectile_updater_advanced_2d()
			projectile_updater_2d = ProjectileEngine.projectile_updater_2d_nodes.get(
				projectile_template_2d.projectile_area_rid
				)

		ProjectileTemplateCustom2D:
			if !is_instance_valid(
				ProjectileEngine.projectile_updater_2d_nodes.get(
					projectile_template_2d.projectile_area_rid
					)
			):
				create_projectile_updater_custom_2d()
			projectile_updater_2d = ProjectileEngine.projectile_updater_2d_nodes.get(
				projectile_template_2d.projectile_area_rid
				)

		ProjectileTemplateNode2D:
			if !is_instance_valid(
				ProjectileEngine.projectile_node_manager_2d_nodes.get(
					projectile_template_2d
					)
			):
				create_projectile_node_manager_2d()
			projectile_node_manager_2d = ProjectileEngine.projectile_node_manager_2d_nodes.get(
				projectile_template_2d
				)
		_:
			return
		#built-in classes don't have a script
		null:
			return

func spawn_pattern() -> void:
	if !active: return
	if !ProjectileEngine.projectile_environment:
		print_debug("No Projectile Environment")
		return

	if !pattern_composer_context:
		pattern_composer_context = PatternComposerContext.new()
	pattern_composer_context.projectile_spawner = self
	pattern_composer_context.use_spawn_markers = use_spawn_markers
	pattern_composer_context.position = global_position
	pattern_composer_context.projectile_template_2d = projectile_template_2d
	if use_spawn_markers:
		pattern_composer_context.projectile_spawn_markers = projectile_spawn_markers
	else:
		pattern_composer_context.projectile_spawn_markers.clear()

	if typeof(projectile_template_2d) != TYPE_OBJECT:
		return
	if !projectile_composer:
		setup_projectile_spawner()
	play_audio()
	match projectile_template_2d.get_script():
		ProjectileTemplateNode2D:
			_pattern_composer_pack = projectile_composer.request_pattern(pattern_composer_context)
			projectile_node_manager_2d.spawn_projectile_pattern(_pattern_composer_pack)
			projectile_spawned.emit(projectile_template_2d)
		ProjectileTemplateAdvanced2D:
			_pattern_composer_pack = projectile_composer.request_pattern(pattern_composer_context)
			projectile_updater_2d.spawn_projectile_pattern(_pattern_composer_pack)
			projectile_spawned.emit(projectile_template_2d)

		_:
			_pattern_composer_pack = projectile_composer.request_pattern(pattern_composer_context)
			projectile_updater_2d.spawn_projectile_pattern(_pattern_composer_pack)
			projectile_spawned.emit(projectile_template_2d)

		## built-in classes don't have a script
		null:
			return

	pass


func create_projectile_updater() -> void:
	if !ProjectileEngine.projectile_environment:
		return

	var _projectile_updater := ProjectileUpdater2D.new()

	_projectile_updater.projectile_template_2d = projectile_template_2d
	_projectile_updater.custom_data = projectile_template_2d.custom_data

	ProjectileEngine.projectile_environment.add_child(_projectile_updater, true)
	projectile_area = _projectile_updater.projectile_area_rid
	projectile_template_2d.projectile_area_rid = _projectile_updater.projectile_area_rid
	ProjectileEngine.projectile_updater_2d_nodes.get_or_add(projectile_area, _projectile_updater)
	projectile_updater_2d = _projectile_updater
	pass


func create_projectile_updater_simple_2d() -> void:
	if !ProjectileEngine.projectile_environment:
		return

	var _projectile_updater := ProjectileUpdaterSimple2D.new()

	_projectile_updater.projectile_template_2d = projectile_template_2d
	_projectile_updater.custom_data = projectile_template_2d.custom_data

	ProjectileEngine.projectile_environment.add_child(_projectile_updater, true)
	projectile_area = _projectile_updater.projectile_area_rid
	projectile_template_2d.projectile_area_rid = _projectile_updater.projectile_area_rid
	ProjectileEngine.projectile_updater_2d_nodes.get_or_add(projectile_area, _projectile_updater)
	projectile_updater_2d = _projectile_updater
	pass


func create_projectile_updater_advanced_2d() -> void:
	if !ProjectileEngine.projectile_environment:
		return

	var _projectile_updater := ProjectileUpdaterAdvanced2D.new()

	_projectile_updater.projectile_template_2d = projectile_template_2d
	_projectile_updater.custom_data = projectile_template_2d.custom_data

	ProjectileEngine.projectile_environment.add_child(_projectile_updater, true)
	projectile_area = _projectile_updater.projectile_area_rid
	projectile_template_2d.projectile_area_rid = _projectile_updater.projectile_area_rid
	ProjectileEngine.projectile_updater_2d_nodes.get_or_add(projectile_area, _projectile_updater)
	projectile_updater_2d = _projectile_updater
	pass


func create_projectile_updater_custom_2d() -> void:
	if !ProjectileEngine.projectile_environment:
		return

	var _projectile_updater := ProjectileUpdaterCustom2D.new()

	_projectile_updater.projectile_template_2d = projectile_template_2d
	_projectile_updater.custom_data = projectile_template_2d.custom_data

	ProjectileEngine.projectile_environment.add_child(_projectile_updater, true)
	projectile_area = _projectile_updater.projectile_area_rid
	projectile_template_2d.projectile_area_rid = _projectile_updater.projectile_area_rid
	ProjectileEngine.projectile_updater_2d_nodes.get_or_add(projectile_area, _projectile_updater)
	projectile_updater_2d = _projectile_updater
	pass


func create_projectile_node_manager_2d() -> void:
	if !ProjectileEngine.projectile_environment:
		return

	var _projectile_node_manager := ProjectileNodeManager2D.new()
	_projectile_node_manager.projectile_template_2d = projectile_template_2d

	ProjectileEngine.projectile_environment.add_child(_projectile_node_manager, true)
	_projectile_node_manager.owner = ProjectileEngine.projectile_environment
	ProjectileEngine.projectile_node_manager_2d_nodes.get_or_add(
		projectile_template_2d, _projectile_node_manager
		)
	_projectile_node_manager.setup_projectile_manager()
	pass


func setup_spawn_marker() -> void:
	projectile_spawn_markers.clear()
	for child : Node in get_children():
		if child is ProjectileSpawnMarker2D:
			projectile_spawn_markers.append(child)


func deactive_projectile_spanwer() -> void:
	disconnect_timing_scheduler()
	disconnect_audio()
	pass


func _spawn_projectile_template_node_2d() -> void:
	if _projectile_2d_instance == null: return
	var _new_projectile_2d : Projectile2D
	for _pattern_composer_data : PatternComposerData in pattern_composer_pack:
		##TODO Instance Node is expensive, need object pooling or better way to instance
		_new_projectile_2d = _projectile_2d_instance.duplicate()
		_new_projectile_2d.apply_pattern_composer_data(_pattern_composer_data)
		ProjectileEngine.projectile_environment.add_child(_new_projectile_2d, true)
		_new_projectile_2d.owner = ProjectileEngine.projectile_environment
		pass
	pass


func connect_timing_scheduler() -> void:
	if !timing_scheduler: return
	timing_scheduler.active = true
	if !timing_scheduler.scheduler_timed.is_connected(spawn_pattern):
		timing_scheduler.scheduler_timed.connect(spawn_pattern)
	pass


func disconnect_timing_scheduler() -> void:
	if !timing_scheduler: return
	timing_scheduler.active = false
	if timing_scheduler.scheduler_timed.is_connected(spawn_pattern):
		timing_scheduler.scheduler_timed.disconnect(spawn_pattern)
	# timing_scheduler.stop_scheduler()
	pass


func play_audio() -> void:
	# audio_stream.playing = true
	if audio_stream_2d:
		print("play aduio")
		audio_stream_2d.playing = true
	pass


func connect_audio() -> void:
	# if audio_stream_2d:
	# 	projectile_spawned.connect(play_audio)
	# if !timing_scheduler.scheduler_timed.is_connected(play_audio):
	
	# if !audio_stream: return
	# if !timing_scheduler.scheduler_timed.is_connected(play_audio):
	# 	timing_scheduler.scheduler_timed.connect(play_audio)
	# if !audio_stream_2d: return
	# if !timing_scheduler.scheduler_timed.is_connected(play_audio):
	# 	timing_scheduler.scheduler_timed.connect(play_audio)
	pass

func disconnect_audio() -> void:
	# if !audio_stream: return
	# if timing_scheduler.scheduler_timed.is_connected(play_audio):
	# 	timing_scheduler.scheduler_timed.disconnect(play_audio)
	# if !audio_stream_2d: return
	# if !timing_scheduler.scheduler_timed.is_connected(play_audio):
	# 	timing_scheduler.scheduler_timed.disconnect(play_audio)
	pass


func _instance_node(_file_path: String) -> Node:
	var _packed_scene : PackedScene = load(_file_path)
	if !_packed_scene:
		print_debug("Scene not valid: " + _file_path)
		print_stack()
		return null
	var _node_instance : Node = _packed_scene.instantiate()
	if !_node_instance:
		print_debug("Node not valid: " + _file_path)
		print_stack()
		return null
	return _node_instance


func _load_projectile_node(_file_path: String) -> PackedScene:
	var _packed_projectile_node : PackedScene = load(_file_path)
	if !_packed_projectile_node:
		print_debug("Scene not valid: " + _file_path)
		print_stack()
		return null
	return _packed_projectile_node
	pass
