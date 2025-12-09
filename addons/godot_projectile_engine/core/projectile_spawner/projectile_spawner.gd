@icon("uid://dhtd7y4cpej7o")
extends Node2D
class_name ProjectileSpawner2D

signal spawn_timed
signal scheduler_completed
signal projectile_spawned(_projectile_template: ProjectileTemplate2D)

@export var active: bool = true:
	set(value):
		active = value
		if active:
			activate_projectile_spawner()
		else:
			deactive_projectile_spanwer()
@export var projectile_template_2d: ProjectileTemplate2D
@export var pattern_composer_name: String
@export var timing_scheduler: TimingScheduler
@export var use_spawn_markers: bool = false
@export_group("Audio")
@export var audio_stream: AudioStreamPlayer
@export var audio_stream_2d: AudioStreamPlayer2D


var projectile_area_rid: RID

var projectile_spawn_markers: Array[ProjectileSpawnMarker2D]

var projectile_composer: PatternComposer2D
var pattern_composer_context: PatternComposerContext
var pattern_composer_pack: Array

var projectile_updater_2d: ProjectileUpdater2D
var projectile_node_manager_2d: ProjectileNodeManager2D
var projectile_count: int = 0

var _projectile_2d_instance: Projectile2D
var _pattern_composer_pack: Array

var _check_projectile_updater: Variant

func _ready() -> void:
	setup_spawn_marker()
	if active:
		activate_projectile_spawner()
	pass


func activate_projectile_spawner() -> void:
	connect_timing_scheduler()
	pass


func spawn_pattern() -> void:
	if !active: return
	if !ProjectileEngine.projectile_environment:
		print_debug("No Projectile Environment")
		return

	if typeof(projectile_template_2d) != TYPE_OBJECT:
		print_debug("Projectile template is not Valid")
		return

	setup_pattern_composer_context()

	if !projectile_composer:
		projectile_composer = ProjectileEngine.get_pattern_composer(pattern_composer_name)

	play_audio()

	# Each template will have a dedicated updater, use the same or create new if not exist 
	_check_projectile_updater = ProjectileEngine.get_updater_node(projectile_template_2d)
	if !_check_projectile_updater:
		create_projectile_updater()
	elif projectile_updater_2d != _check_projectile_updater:
		projectile_updater_2d = _check_projectile_updater

	_pattern_composer_pack = projectile_composer.request_pattern(pattern_composer_context)
	match projectile_template_2d.get_script():
		ProjectileTemplateNode2D:
			projectile_node_manager_2d.spawn_projectile_pattern(_pattern_composer_pack)
			projectile_spawned.emit(projectile_template_2d)
		ProjectileTemplateSimple2D, ProjectileTemplateAdvanced2D, ProjectileTemplateCustom2D:
			projectile_updater_2d.spawn_projectile_pattern(_pattern_composer_pack)
			projectile_spawned.emit(projectile_template_2d)
		null:
			return
	pass


func create_projectile_updater() -> void:
	match projectile_template_2d.get_script():
		ProjectileTemplateSimple2D:
			create_projectile_updater_simple_2d()

		ProjectileTemplateAdvanced2D:
			create_projectile_updater_advanced_2d()

		ProjectileTemplateCustom2D:
			create_projectile_updater_custom_2d()

		ProjectileTemplateNode2D:
			create_projectile_node_manager_2d()
		_:
			return
		#built-in classes don't have a script
		null:
			return

func create_projectile_updater_simple_2d() -> ProjectileUpdater2D:
	if !ProjectileEngine.projectile_environment:
		return

	projectile_updater_2d = ProjectileUpdaterSimple2D.new()

	projectile_updater_2d.projectile_template_2d = projectile_template_2d
	ProjectileEngine.projectile_environment.add_child(projectile_updater_2d, true)
	projectile_area_rid = projectile_updater_2d.projectile_area_rid
	projectile_template_2d.projectile_area_rid = projectile_updater_2d.projectile_area_rid
	ProjectileEngine.projectile_updater_2d_nodes.get_or_add(projectile_area_rid, projectile_updater_2d)
	return projectile_updater_2d


func create_projectile_updater_advanced_2d() -> void:
	if !ProjectileEngine.projectile_environment:
		return

	projectile_updater_2d = ProjectileUpdaterAdvanced2D.new()

	projectile_updater_2d.projectile_template_2d = projectile_template_2d
	ProjectileEngine.projectile_environment.add_child(projectile_updater_2d, true)
	projectile_area_rid = projectile_updater_2d.projectile_area_rid
	projectile_template_2d.projectile_area_rid = projectile_updater_2d.projectile_area_rid
	ProjectileEngine.projectile_updater_2d_nodes.get_or_add(projectile_area_rid, projectile_updater_2d)
	pass


func create_projectile_updater_custom_2d() -> void:
	if !ProjectileEngine.projectile_environment:
		return

	var _projectile_updater := ProjectileUpdaterCustom2D.new()

	_projectile_updater.projectile_template_2d = projectile_template_2d
	ProjectileEngine.projectile_environment.add_child(_projectile_updater, true)
	projectile_area_rid = _projectile_updater.projectile_area_rid
	projectile_template_2d.projectile_area_rid = _projectile_updater.projectile_area_rid
	ProjectileEngine.projectile_updater_2d_nodes.get_or_add(projectile_area_rid, _projectile_updater)
	projectile_updater_2d = _projectile_updater
	pass


func create_projectile_node_manager_2d() -> void:
	if !ProjectileEngine.projectile_environment:
		return

	projectile_node_manager_2d = ProjectileNodeManager2D.new()
	projectile_node_manager_2d.projectile_template_2d = projectile_template_2d

	ProjectileEngine.projectile_environment.add_child(projectile_node_manager_2d, true)
	projectile_node_manager_2d.owner = ProjectileEngine.projectile_environment

	if ProjectileEngine.projectile_node_manager_2d_nodes.has(projectile_template_2d):
		ProjectileEngine.projectile_node_manager_2d_nodes.set(projectile_template_2d, projectile_node_manager_2d)
	else:
		ProjectileEngine.projectile_node_manager_2d_nodes.get_or_add(
			projectile_template_2d, projectile_node_manager_2d
			)
	projectile_node_manager_2d.setup_projectile_manager()
	pass


func setup_pattern_composer_context() -> void:
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
	pass


func setup_spawn_marker() -> void:
	projectile_spawn_markers.clear()
	for child: Node in get_children():
		if child is ProjectileSpawnMarker2D:
			projectile_spawn_markers.append(child)


func deactive_projectile_spanwer() -> void:
	disconnect_timing_scheduler()
	pass


func _spawn_projectile_template_node_2d() -> void:
	if _projectile_2d_instance == null: return
	var _new_projectile_2d: Projectile2D
	for _pattern_composer_data: PatternComposerData in pattern_composer_pack:
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
	pass


func play_audio() -> void:
	if audio_stream:
		audio_stream.playing = true
	if audio_stream_2d:
		audio_stream_2d.playing = true
	pass
