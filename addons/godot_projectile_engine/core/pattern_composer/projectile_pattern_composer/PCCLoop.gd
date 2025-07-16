
extends PatternComposerComponent
class_name PCCLoop

## Loop through all child Pattern Components a number of times
## Make Input Array[PatternComposerData] Loop through child 
## Pattern Components numbers of times. Basically duplicate 
## the child Pattern Components reuslts N time

@export var loop_count : int = 3

func _physics_process(delta: float) -> void:
	pass

func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	if !active: return pattern_composer_pack

	var _new_pattern_composer_pack : Array[PatternComposerData] = []

	for i in range(loop_count):
		var _new_child_packs : Array[PatternComposerData] = pattern_composer_pack.duplicate()
		for pattern_component in get_children():
			if pattern_component is not PatternComposerComponent: continue
			if !pattern_component.active: continue 
			_new_child_packs = pattern_component.process_pattern(_new_child_packs, _pattern_composer_context)

		for pattern_data : PatternComposerData in _new_child_packs:
			var _new_pattern_data := PatternComposerData.new()
			_new_pattern_data.position = pattern_data.position
			_new_pattern_data.direction = pattern_data.direction
			_new_pattern_data.rotation = pattern_data.rotation
			_new_pattern_data.speed_mod = pattern_data.speed_mod
			_new_pattern_composer_pack.append(_new_pattern_data)
	return _new_pattern_composer_pack
