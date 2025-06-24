extends ProjectileTriggerCondition2D
class_name PTCPosition

@export var target_position : Vector2 = Vector2.ZERO
@export var trigger_radius : float = 50.0

func check_trigger_condition(trigger_name: String, active_projectile_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _projectile_instance in active_projectile_instances:
		if !_projectile_instance.is_trigger: continue
		var distance_to_target = _projectile_instance.global_position.distance_to(target_position)
		if distance_to_target <= trigger_radius:
			ProjectileEngine.projectile_instance_triggered.emit(trigger_name, _projectile_instance)
			if one_shot:
				_projectile_instance.is_trigger = false
