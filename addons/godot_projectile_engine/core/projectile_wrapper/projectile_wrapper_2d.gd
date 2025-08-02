extends Node2D
class_name ProjectileWrapper2D

@export var active : bool = false:
	set(value):
		active = value
		if is_instance_valid(projectile_spawner):
			projectile_spawner.active = value
@export var projectile_wrapper_name : String
@export var projectile_spawner : ProjectileSpawner2D



func _enter_tree() -> void:
	_register_projectile_wrapper(projectile_wrapper_name)
	if active and is_instance_valid(projectile_spawner):
		projectile_spawner.active = active
	pass


func _exit_tree() -> void:
	_deregister_projectile_wrapper(projectile_wrapper_name)
	pass

func _register_projectile_wrapper(_projectile_wrapper_name: String) -> void:
	if _projectile_wrapper_name == "": return
	_deregister_projectile_wrapper(_projectile_wrapper_name)
	if ProjectileEngine.projectile_wrapper_2d.has(_projectile_wrapper_name): 
		print_debug("Composer name: ", _projectile_wrapper_name, " is existed: ", ProjectileEngine.projectile_wrapper_2d.get(_projectile_wrapper_name))
		return
	ProjectileEngine.projectile_wrapper_2d.get_or_add(_projectile_wrapper_name, self)
	pass

func _deregister_projectile_wrapper(_projectile_wrapper_name: String) -> void:
	if _projectile_wrapper_name == "": return
	ProjectileEngine.projectile_wrapper_2d.erase(_projectile_wrapper_name)
	pass
