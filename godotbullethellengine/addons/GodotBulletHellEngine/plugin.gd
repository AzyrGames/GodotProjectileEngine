@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_autoload_singleton("BulletHell", "res://addons/GodotBulletHellEngine/Core/BulletHell.gd")
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_autoload_singleton("BulletHell")
	pass
