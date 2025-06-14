extends Node
class_name ProjectileComponent

@export var active : bool = true:
	set(value):
		active = value
		if value:
			active_component()
		else:
			deactive_compoment()

func active_component() -> void:
	pass

func deactive_compoment() -> void:
	pass


func _ready() -> void:
	pass

func process_projectile_component() -> Variant:
	return