extends Node2D
class_name BulletComposer2D

# @export var spawn_timing: 
# @export var spawn_maker : Marker2D

@export var composer_name : String:
	set(value):
		if composer_name != null:
			BulletHell.bullet_composer_nodes.erase(composer_name)
		if value != null:
			BulletHell.bullet_composer_nodes.get_or_add(value, self)
		composer_name = value
		

func _enter_tree() -> void:
	if composer_name != null:
		BulletHell.bullet_composer_nodes.get_or_add(composer_name, self)
	pass

func _exit_tree() -> void:
	if composer_name != null:
		BulletHell.bullet_composer_nodes.erase(composer_name)
	pass

func create_pattern(_position: Vector2, _composer_var : Dictionary) -> Array:
	var pattern_packs : Array = [
		{
			"direction" : Vector2.RIGHT,
			"position" : _position
		}
	]
	for pattern_component in get_children():
		if pattern_component is not BPCBase: continue
		if !pattern_component.active: continue
		pattern_packs = pattern_component.process_pattern(pattern_packs, _composer_var)

	return pattern_packs


# func _get_spawn_maker_pos() -> Vector2:
