extends BulletTriggerCondition2D
class_name BTCTime

@export var time : float

func check_trigger_condition(active_bullet_instances: Array[BulletInstance2D]) -> void:
	if !is_active : return
	for _bullet_instance in active_bullet_instances:
		if !_bullet_instance.is_trigger: continue
		if _bullet_instance.life_time >= time:
			BulletHell.bullet_trigger_activated.emit(_bullet_instance)
			if one_shot:
				_bullet_instance.is_trigger = false
			
	pass
