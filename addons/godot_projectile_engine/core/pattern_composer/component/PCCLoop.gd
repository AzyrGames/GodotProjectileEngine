@icon("uid://cnujqg7xhs2np")
extends PatternComposerComponent
class_name PCCLoop

## Loop through all child Pattern Components a number of times
## Make Input Array[PatternComposerData] Loop through child 
## Pattern Components numbers of times. Basically duplicate 
## the child Pattern Components reuslts N time

var _new_sub_pattern_composer_data: Array[PatternComposerData]

@export var loop_count : int = 3

func _physics_process(delta: float) -> void:
	pass

func process_pattern(
	_pattern_composer_pack: Array[PatternComposerData], 
	_pattern_composer_context : PatternComposerContext
	) -> Array:
	if !active: return _pattern_composer_pack

	_new_pattern_composer_pack.clear()
	for i in range(loop_count):
		_new_sub_pattern_composer_data.clear()
		_new_sub_pattern_composer_data = _pattern_composer_pack.duplicate()
		for pattern_component in get_children():
			if pattern_component is not PatternComposerComponent: continue
			if !pattern_component.active: continue 
			_new_sub_pattern_composer_data = pattern_component.process_pattern(
				_new_sub_pattern_composer_data, _pattern_composer_context
				)
		_new_pattern_composer_pack.append_array(_new_sub_pattern_composer_data)
	return _new_pattern_composer_pack
