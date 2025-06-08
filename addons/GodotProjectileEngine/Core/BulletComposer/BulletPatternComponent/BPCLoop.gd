## Bullet Pattern Component Base
## Loop through all Bullet Pattern Components a number of times
extends BPCBase
class_name BPCLoop

@export var loop_count : int = 1

func _physics_process(delta: float) -> void:
	pass

func process_pattern(pattern_packs: Array, _composer_var : Dictionary) -> Array:
	if !active: return pattern_packs

	var _new_pattern_packs := []

	for i in range(loop_count):
		var _new_child_packs := pattern_packs.duplicate()
		for pattern_component in get_children():
			if pattern_component is not BPCBase: continue
			if !pattern_component.active: continue 
			_new_child_packs = pattern_component.process_pattern(_new_child_packs, _composer_var)

		for pack : Dictionary in _new_child_packs:
			_new_pattern_packs.append(pack.duplicate(true))
	return _new_pattern_packs
