@icon("uid://wonyn8c6ckbd")
extends Node2D
class_name ProjectileWrapper2D

@export var active : bool = false:
	set(value):
		active = value
		if is_instance_valid(projectile_spawner_2d):
			projectile_spawner_2d.active = value
@export var projectile_wrapper_name : String
@export var projectile_spawner_2d : ProjectileSpawner2D




func _exit_tree() -> void:
	_deregister_projectile_wrapper(projectile_wrapper_name)
	pass

func _ready() -> void:
	_register_projectile_wrapper(projectile_wrapper_name)
	if active and is_instance_valid(projectile_spawner_2d):
		projectile_spawner_2d.active = active

func _register_projectile_wrapper(_projectile_wrapper_name: String) -> void:
	if _projectile_wrapper_name == "": return
	_deregister_projectile_wrapper(_projectile_wrapper_name)
	if ProjectileEngine.projectile_wrapper_2d_nodes.has(_projectile_wrapper_name): 
		var _projectile_wrapper_nodes = ProjectileEngine.projectile_wrapper_2d_nodes.get(_projectile_wrapper_name)
		_projectile_wrapper_nodes.append(self)
	else:
		ProjectileEngine.projectile_wrapper_2d_nodes.get_or_add(_projectile_wrapper_name, [self])
	pass

func _deregister_projectile_wrapper(_projectile_wrapper_name: String) -> void:
	if _projectile_wrapper_name == "": return
	if ProjectileEngine.projectile_wrapper_2d_nodes.has(_projectile_wrapper_name):
		var _projectile_wrapper_nodes = ProjectileEngine.projectile_wrapper_2d_nodes.get(_projectile_wrapper_name)
		_projectile_wrapper_nodes.erase(self)
		if _projectile_wrapper_nodes.size() <= 0:
			ProjectileEngine.projectile_wrapper_2d_nodes.erase(_projectile_wrapper_name)
			
