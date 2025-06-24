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

func check_trigger_condition(trigger_name: String, active_projectile_instances: Array[ProjectileInstance2D]) -> void:
	if !is_active : return
	for _projectile_instance in active_projectile_instances:
		if !_projectile_instance.is_trigger: continue
		
		var should_trigger = false
		match trigger_mode:
			TriggerMode.BELOW:
				should_trigger = _projectile_instance.move_speed < target_speed
			TriggerMode.ABOVE:
				should_trigger = _projectile_instance.move_speed > target_speed
			TriggerMode.EQUAL:
				should_trigger = abs(_projectile_instance.move_speed - target_speed) <= speed_threshold
		
		if should_trigger:
			ProjectileEngine.projectile_instance_triggered.emit(trigger_name, _projectile_instance)
			if one_shot:
				_projectile_instance.is_trigger = false
