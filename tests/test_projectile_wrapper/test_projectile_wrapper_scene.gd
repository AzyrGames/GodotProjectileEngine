extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProjectileEngine.activate_all_projectile_wrappers("")
	ProjectileEngine.activate_all_projectile_wrappers("wrong_wrapper")
	ProjectileEngine.activate_all_projectile_wrappers("test_wrapper_node_1")
	ProjectileEngine.deactivate_all_projectile_wrappers("test_wrapper_node_1")
