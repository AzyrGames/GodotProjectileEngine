## The base class for Projectile Pattern Component, this node does nothing by itself

extends Node
class_name PatternComposerComponent

@export var active: bool = true

func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	return pattern_composer_pack


func update(pattern_composer_pack : Array[PatternComposerData]) -> void:
	pass