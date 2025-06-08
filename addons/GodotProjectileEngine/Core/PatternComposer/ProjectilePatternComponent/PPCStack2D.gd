## Bullet Pattern Component Base

extends ProjectilePatternComponent
class_name PPCStack2D

@export var stack_amount : int = 3
@export var stack_distance : float = 15.0

var _offset : Vector2

var _new_pattern_instance : Dictionary

func process_pattern(pattern_packs: Array, _composer_var : Dictionary) -> Array:
	var _new_pattern_packs := []
	for _pattern_instance : Dictionary in pattern_packs:
		for i in stack_amount:
			_new_pattern_instance = _pattern_instance.duplicate()

			_offset = i * stack_distance * _pattern_instance.direction
			_new_pattern_instance.position = _pattern_instance.position + _offset

			_new_pattern_packs.append(_new_pattern_instance)
	return _new_pattern_packs