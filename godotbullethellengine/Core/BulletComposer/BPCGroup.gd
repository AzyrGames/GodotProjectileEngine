## Bullet Pattern Component Base

extends BPCBase
class_name BPCGroup



func process_pattern(pattern_packs: Array, _composer_var : Dictionary) -> Array:
	var _new_pattern_packs := []
	for instance : Dictionary in pattern_packs:
		var _sub_pattern_packs := [instance]

		for pattern_component in get_children():
			if pattern_component is not BPCBase: continue
			if !pattern_component.active: continue 
			_sub_pattern_packs = pattern_component.process_pattern(_sub_pattern_packs)

		_new_pattern_packs.append_array(_sub_pattern_packs)
	return _new_pattern_packs

