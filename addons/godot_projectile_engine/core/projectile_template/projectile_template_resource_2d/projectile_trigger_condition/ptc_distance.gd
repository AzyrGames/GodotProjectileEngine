extends ProjectileTriggerCondition2D
class_name PTCDistance

@export var distance : float = 100.0

func check_trigger_condition(trigger_name: String, active_bullet_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _bullet_instance in active_bullet_instances:
		if !_bullet_instance.is_trigger: continue
		if _bullet_instance.life_distance >= distance:
			ProjectileEngine.bullet_trigger_activated.emit(trigger_name, _bullet_instance)
			if one_shot:
				_bullet_instance.is_trigger = false
