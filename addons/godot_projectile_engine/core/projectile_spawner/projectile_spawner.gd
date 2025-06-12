# @tool
extends Node2D
class_name BulletSpawner2D

@export var active : bool = true:
	set(value):
		active = value
		if active:
			activate_bullet_spawner()
		else:
			deactive_bullet_spanwer()


var bullet_area : RID

@export var bullet_composer_name : String
var bullet_composer : PatternComposer2D

@export var bullet_template_2d : ProjectileTemplate2D
@export var timing_scheduler : TimingScheduler

@export var audio_stream: AudioStreamPlayer

var pattern_packs: Array

var bullet_updater_2d : ProjectileUpdater2D

var bullet_count: int = 0


signal spawn_timed
signal scheduler_completed

func _exit_tree() -> void:
	pass

func _enter_tree() -> void:
	pass


func _ready() -> void:
	if active:
		activate_bullet_spawner()
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func setup_bullet_spawner() -> void:
	bullet_composer = ProjectileEngine.bullet_composer_nodes.get(bullet_composer_name)

	if !bullet_composer:
		print_debug(bullet_composer_name + " PatternComposer ID is not valid")
		return
	if bullet_template_2d is ProjectileTemplateResource2D:
		if !is_instance_valid(ProjectileEngine.bullet_updater_2d_nodes.get(bullet_template_2d.bullet_area_rid)):
			create_bullet_updater()
		bullet_updater_2d = ProjectileEngine.bullet_updater_2d_nodes.get(bullet_template_2d.bullet_area_rid)

	elif bullet_template_2d is ProjectileTemplateNode2D:
		pass
	else:
		pass


func activate_bullet_spawner() -> void:
	setup_bullet_spawner()
	connect_timing_scheduler()
	connect_audio()
	pass

func deactive_bullet_spanwer() -> void:
	disconnect_timing_scheduler()
	disconnect_audio()
	pass


var composer_var : Dictionary


func spawn_pattern() -> void:
	if !active: return
	if !ProjectileEngine.projectile_environment:
		print_debug("No Projectile Environment")
		return
	pattern_packs = bullet_composer.request_pattern(global_position, composer_var)

	# match bullet_template_2d:
	if bullet_template_2d is ProjectileTemplateResource2D:
		_spawn_projectile_template_resource_2d()
	elif bullet_template_2d is ProjectileTemplateResource2D:
		_spawn_projectile_template_node_2d()
	else:
		pass
	pass


func _spawn_projectile_template_resource_2d() -> void:
	bullet_updater_2d.spawn_bullet_pattern(pattern_packs)
	pass


func _spawn_projectile_template_node_2d() -> void:
	pass


var remove_array : Array

func create_bullet_updater() -> void:
	var _bullet_updater := ProjectileUpdater2D.new()

	_bullet_updater.bullet_template_2d = bullet_template_2d

	ProjectileEngine.projectile_environment.add_child(_bullet_updater)
	bullet_area = _bullet_updater.bullet_area_rid 
	bullet_template_2d.bullet_area_rid = _bullet_updater.bullet_area_rid 
	ProjectileEngine.bullet_updater_2d_nodes.get_or_add(bullet_area, _bullet_updater)
	bullet_updater_2d = _bullet_updater

	pass

func connect_timing_scheduler() -> void:
	if !timing_scheduler: return
	timing_scheduler.scheduler_timed.connect(spawn_pattern)
	timing_scheduler.start_scheduler()
	pass

func disconnect_timing_scheduler() -> void:
	if !timing_scheduler: return
	timing_scheduler.scheduler_timed.disconnect(spawn_pattern)
	timing_scheduler.stop_scheduler()
	pass


func play_audio() -> void:
	if !audio_stream: return
	audio_stream.playing = true
	pass

func connect_audio() -> void:
	if !audio_stream: return
	timing_scheduler.scheduler_timed.connect(play_audio)
	pass

func disconnect_audio() -> void:
	if !audio_stream: return
	timing_scheduler.scheduler_timed.disconnect(play_audio)
	pass
