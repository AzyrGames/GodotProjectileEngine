extends ProjectileTriggerCondition2D
class_name PTCTime

@export var time : float = 1.0

func check_trigger_condition(trigger_name: String, active_projectile_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _projectile_instance in active_projectile_instances:
		if !_projectile_instance.is_trigger: continue
		var trigger_times : Variant = _projectile_instance.trigger_dict.get_or_add("trigger_times", 1)
		if _projectile_instance.life_time >= time * trigger_times:
			ProjectileEngine.projectile_instance_triggered.emit(trigger_name, _projectile_instance)
			if one_shot:
				_projectile_instance.is_trigger = false
				continue
			trigger_times += 1 
			_projectile_instance.trigger_dict.set("trigger_times", trigger_times)
	pass
