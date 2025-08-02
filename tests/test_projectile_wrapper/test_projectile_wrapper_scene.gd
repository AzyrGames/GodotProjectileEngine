extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProjectileEngine.active_all_projectile_wrappers("")
	ProjectileEngine.active_all_projectile_wrappers("wrong_wrapper")
	ProjectileEngine.active_all_projectile_wrappers("test_wrapper_node_1")
	ProjectileEngine.deactive_all_projectile_wrappers("test_wrapper_node_1")
