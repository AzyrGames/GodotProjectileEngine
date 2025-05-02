extends Resource
class_name BulletTriggerCondition2D


@export var is_active : bool = true
@export var one_shot : bool = true


func check_trigger_condition(active_bullet_instances: Array[BulletInstance2D]) -> void:
	pass
