extends BulletTriggerCondition2D
class_name BTCTime

@export var time : float

func check_trigger_condition(active_bullet_instances: Array[BulletInstance2D]) -> void:

	for _bullet_instance in active_bullet_instances:
		if _bullet_instance.life_time >= time:
			BulletHell.bullet_trigger_activated.emit(_bullet_instance)
	pass
