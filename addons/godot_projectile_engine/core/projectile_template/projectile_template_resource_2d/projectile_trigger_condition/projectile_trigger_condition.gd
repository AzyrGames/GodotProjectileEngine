extends Resource
class_name ProjectileTriggerCondition2D


@export var is_active : bool = true
@export var one_shot : bool = true

@export var destroy_on_trigger : bool = true


func check_trigger_condition(trigger_name: String, active_projectile_instances: Array[ProjectileInstance2D]) -> void:
	pass
