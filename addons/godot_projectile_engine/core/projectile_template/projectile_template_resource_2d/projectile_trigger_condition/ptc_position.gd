extends ProjectileTriggerCondition2D
class_name PTCPosition

@export var target_position : Vector2 = Vector2.ZERO
@export var trigger_radius : float = 50.0

func check_trigger_condition(trigger_name: String, active_bullet_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _bullet_instance in active_bullet_instances:
		if !_bullet_instance.is_trigger: continue
		var distance_to_target = _bullet_instance.global_position.distance_to(target_position)
		if distance_to_target <= trigger_radius:
			ProjectileEngine.bullet_trigger_activated.emit(trigger_name, _bullet_instance)
			if one_shot:
				_bullet_instance.is_trigger = false
