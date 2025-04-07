extends Node
class_name BulletComposer2D

# @export var spawn_timing: 
@export var spawn_maker : Marker2D

func create_pattern() -> Array:
	var pattern_packs : Array = [
		{
			"direction" : Vector2.RIGHT,
			"position" : spawn_maker.global_position
		}
	]
	for pattern_component in get_children():
		if pattern_component is not BPCBase: continue
		if !pattern_component.active: continue 
		pattern_packs = pattern_component.process_pattern(pattern_packs)

	return pattern_packs


# func _get_spawn_maker_pos() -> Vector2:
