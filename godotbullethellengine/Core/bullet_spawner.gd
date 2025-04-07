@tool
extends Node2D
class_name BulletSpawner2D

@export var active : bool = true


var bullet_area : RID

@export var bullet_template_2d : BulletTemplate2D

@export var bullet_composer : BulletComposer2D
var pattern_packs: Array

@export var bullet_scheduler : BulletScheduler:
	set(value):
		if value:
			bullet_scheduler = value
			setup_bullet_scheduler()
		else:
			disconnect_bullet_scheduler()


var bullet_count: int = 0


func _exit_tree() -> void:
	bullet_scheduler.stop_scheduler()
	# BulletHell.bullet_environment.spawner_destroyed(bullet_area)
	pass

func _enter_tree() -> void:
	pass


func _ready() -> void:

	pass

func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:

	pass



func spawn_bullet() -> void:
	if !active: return
	pattern_packs = bullet_composer.create_pattern()

	if !BulletHell.bullet_environment:
		print_debug("No Projectile Environment")
		return
	if !BulletHell.bullet_environment.bullet_updater_node.has(bullet_area):
		create_bullet_updater()


	BulletHell.bullet_environment.bullet_updater_node.get(bullet_area).spawn_bullet(pattern_packs)

	pass


var remove_array : Array


func create_bullet_updater() -> void:
	var _bullet_updater := BulletUpdater2D.new()

	_bullet_updater.bullet_template_2d = bullet_template_2d

	BulletHell.bullet_environment.add_child(_bullet_updater)
	BulletHell.bullet_environment.bullet_updater_node.get_or_add(bullet_area, _bullet_updater)

	pass


func setup_bullet_scheduler() -> void:
	bullet_scheduler.spawn_timed.connect(spawn_bullet)
	pass

func disconnect_bullet_scheduler() -> void:
	print("Hey")
	pass
