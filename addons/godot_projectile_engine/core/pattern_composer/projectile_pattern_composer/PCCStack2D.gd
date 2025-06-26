## Projectile Pattern Component

extends PatternComposerComponent
class_name PCCStack2D

@export var stack_amount : int = 3
@export var stack_distance : float = 15.0

var _offset : Vector2

var _new_pattern_data : PatternComposerData

func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	var _new_pattern_composer_pack : Array[PatternComposerData] = []
	for pattern_data : PatternComposerData in pattern_composer_pack:
		for i in stack_amount:
			_new_pattern_data = PatternComposerData.new()
			_new_pattern_data.position = pattern_data.position
			_new_pattern_data.direction = pattern_data.direction
			_new_pattern_data.rotation = pattern_data.rotation
			_new_pattern_data.speed_mod = pattern_data.speed_mod

			_offset = i * stack_distance * pattern_data.direction
			_new_pattern_data.position = pattern_data.position + _offset

			_new_pattern_composer_pack.append(_new_pattern_data)
	return _new_pattern_composer_pack
