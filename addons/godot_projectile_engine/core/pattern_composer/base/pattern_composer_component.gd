## The base class for Projectile Pattern Component, this node does nothing by itself

extends Node
class_name PatternComposerComponent

@export var active: bool = true

var _new_pattern_composer_pack: Array[PatternComposerData]
var _new_pattern_composer_data: PatternComposerData

func process_pattern(
	_pattern_composer_pack: Array[PatternComposerData], 
	_pattern_composer_context : PatternComposerContext
	) -> Array:
	return _pattern_composer_pack


func update(_pattern_composer_pack : Array[PatternComposerData]) -> void:
	pass