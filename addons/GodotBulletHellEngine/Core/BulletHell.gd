extends Node



signal bullet_trigger_activated(trigger_name: String, bullet_instance: BulletInstance2D)

var active_bullet_count : int

# var bullet_template_2d_nodes : Dictionary[RID, BulletTemplate2D]

var bullet_updater_2d_nodes : Dictionary[RID, BulletUpdater2D]

var bullet_environment : BulletEnvironment2D
# var 

var bullet_homing_targets : Dictionary[String, Array]

var bullet_composer_nodes : Dictionary[String, BulletComposer2D]



func get_bullet_count() -> int:
	active_bullet_count = 0
	# if !bullet_updater_2d_nodes: return
	# if !bullet_template_2d_nodes.size() <= 0: return 0

	for bullet_updater in bullet_updater_2d_nodes.values():
		if bullet_updater:
			active_bullet_count += bullet_updater.get_active_bullet_count()
		pass
	
	return active_bullet_count
	pass


func clear() -> void:
	# bullet_template_2d_nodes.clear()
	bullet_updater_2d_nodes.clear()
	bullet_composer_nodes.clear()
	pass

func clear_bullet() -> void:
	for _bullet_udpater_node in bullet_updater_2d_nodes.values():
		_bullet_udpater_node.clear_bullet()
	pass