extends ProjectileTriggerCondition2D
class_name PTCCount

@export var trigger_count : int = 3
@export var reset_on_trigger : bool = false

func check_trigger_condition(trigger_name: String, active_projectile_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _projectile_instance in active_projectile_instances:
		if !_projectile_instance.is_trigger: continue
		
		var current_count : int = _projectile_instance.trigger_dict.get_or_add("trigger_count", 0)
		current_count += 1
		_projectile_instance.trigger_dict["trigger_count"] = current_count
		
		if current_count >= trigger_count:
			ProjectileEngine.projectile_instance_triggered.emit(trigger_name, _projectile_instance)
			if one_shot:
				_projectile_instance.is_trigger = false
			elif reset_on_trigger:
				_projectile_instance.trigger_dict["trigger_count"] = 0
