## Bullet Pattern Component Base

extends BPCBase
class_name BPCStack2D

@export var stack_amount : int = 3
@export var stack_distance : float = 15.0


func process_pattern(pattern_packs: Array) -> Array:
	var _new_pattern_packs := []
	for instance : Dictionary in pattern_packs:
		for i in stack_amount:
			
			var _new_instance := instance.duplicate()
			var _offset := i * stack_distance * instance.direction as Vector2
			var _point := instance.position + _offset as Vector2

			_new_instance.position = _point

			_new_pattern_packs.append(_new_instance)
	return _new_pattern_packs