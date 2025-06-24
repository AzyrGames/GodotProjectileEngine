extends ProjectileTriggerCondition2D
class_name PTCDistance

@export var distance : float = 100.0

func check_trigger_condition(trigger_name: String, active_projectile_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _projectile_instance in active_projectile_instances:
		if !_projectile_instance.is_trigger: continue
		if _projectile_instance.life_distance >= distance:
			ProjectileEngine.projectile_instance_triggered.emit(trigger_name, _projectile_instance)
			if one_shot:
				_projectile_instance.is_trigger = false
