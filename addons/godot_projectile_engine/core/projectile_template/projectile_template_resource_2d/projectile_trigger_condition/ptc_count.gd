extends ProjectileTriggerCondition2D
class_name PTCCount

@export var trigger_count : int = 3
@export var reset_on_trigger : bool = false

func check_trigger_condition(trigger_name: String, active_bullet_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _bullet_instance in active_bullet_instances:
		if !_bullet_instance.is_trigger: continue
		
		var current_count : int = _bullet_instance.trigger_dict.get_or_add("trigger_count", 0)
		current_count += 1
		_bullet_instance.trigger_dict["trigger_count"] = current_count
		
		if current_count >= trigger_count:
			ProjectileEngine.bullet_trigger_activated.emit(trigger_name, _bullet_instance)
			if one_shot:
				_bullet_instance.is_trigger = false
			elif reset_on_trigger:
				_bullet_instance.trigger_dict["trigger_count"] = 0
