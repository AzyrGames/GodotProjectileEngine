## The base for Bullet Pattern Component, this node does nothing by itself

extends Node
class_name BPCBase

@export var active: bool = true

func process_pattern(pattern_packs: Array) -> Array:
	return pattern_packs

