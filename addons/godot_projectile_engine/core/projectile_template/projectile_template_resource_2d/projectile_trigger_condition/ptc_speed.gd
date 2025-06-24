extends ProjectileTriggerCondition2D
class_name PTCSpeed

@export var target_speed : float = 100.0
@export var speed_threshold : float = 10.0
@export var trigger_mode : TriggerMode = TriggerMode.BELOW

enum TriggerMode {
	BELOW,
	ABOVE,
	EQUAL
}

func check_trigger_condition(trigger_name: String, active_bullet_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _bullet_instance in active_bullet_instances:
		if !_bullet_instance.is_trigger: continue
		
		var should_trigger = false
		match trigger_mode:
			TriggerMode.BELOW:
				should_trigger = _bullet_instance.move_speed < target_speed
			TriggerMode.ABOVE:
				should_trigger = _bullet_instance.move_speed > target_speed
			TriggerMode.EQUAL:
				should_trigger = abs(_bullet_instance.move_speed - target_speed) <= speed_threshold
		
		if should_trigger:
			ProjectileEngine.bullet_trigger_activated.emit(trigger_name, _bullet_instance)
			if one_shot:
				_bullet_instance.is_trigger = false
