extends BulletTriggerCondition2D
class_name BTCTime

@export var time : float

func check_trigger_condition(active_bullet_instances: Array[BulletInstance2D]) -> void:
	if !is_active : return
	for _bullet_instance in active_bullet_instances:
		if !_bullet_instance.is_trigger: continue
		var trigger_times : Variant = _bullet_instance.trigger_dict.get_or_add("trigger_times", 1)
		if _bullet_instance.life_time >= time * trigger_times:
			BulletHell.bullet_trigger_activated.emit(_bullet_instance)
			if one_shot:
				_bullet_instance.is_trigger = false
				continue
			trigger_times += 1 
			_bullet_instance.trigger_dict.set("trigger_times", trigger_times)


	pass
