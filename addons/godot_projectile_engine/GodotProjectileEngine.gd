extends Node



signal bullet_trigger_activated(trigger_name: String, bullet_instance: ProjectileInstance2D)

enum BehviorContext{
	PHYSICS_DELTA,
	LIFE_TIME_TICK,
	LIFE_TIME_SECOND,
	BASE_SPEED,
}


var active_bullet_count : int
var projectile_environment : ProjectileEnvironment2D

var bullet_updater_2d_nodes : Dictionary[RID, ProjectileUpdater2D]

var bullet_composer_nodes : Dictionary[String, PatternComposer2D]



func get_bullet_count() -> int:
	active_bullet_count = 0

	for bullet_updater in bullet_updater_2d_nodes.values():
		if bullet_updater:
			active_bullet_count += bullet_updater.get_active_bullet_count()
		pass
	
	return active_bullet_count
	pass


func clear() -> void:
	bullet_updater_2d_nodes.clear()
	bullet_composer_nodes.clear()
	pass

func clear_bullet() -> void:
	for _bullet_udpater_node in bullet_updater_2d_nodes.values():
		_bullet_udpater_node.clear_bullet()
	pass