extends Node
class_name PatternComposer2D

signal pattern_composed(_pattern_packs: Dictionary)

@export var composer_name : String = "":
	set(value):
		if value == composer_name: return
		_reregister_pattern_composer(composer_name, value)
		composer_name = value


func _enter_tree() -> void:
	_register_pattern_composer(composer_name)
	pass


func _exit_tree() -> void:
	_deregister_pattern_composer(composer_name)
	pass


func _register_pattern_composer(_composer_name: String) -> void:
	if _composer_name == "": return
	if ProjectileEngine.projectile_composer_nodes.has(_composer_name): 
		print_debug("Composer name: ", _composer_name, " is existed: ", ProjectileEngine.projectile_composer_nodes.get(_composer_name))
		return
	ProjectileEngine.projectile_composer_nodes.get_or_add(_composer_name, self)

	# print("registered: {0}".format([_composer_name]))
	pass


func _deregister_pattern_composer(_composer_name: String) -> void:
	if _composer_name == "": return
	ProjectileEngine.projectile_composer_nodes.erase(_composer_name)

	# print("deregistered: {0}".format([_composer_name]))
	pass


func _reregister_pattern_composer(_old_composer_name: String, _new_composer_name: String) -> void:
	_deregister_pattern_composer(_old_composer_name)
	_register_pattern_composer(_new_composer_name)
	
	# print("re-registered: {0} -- {1}".format([_old_composer_name, _new_composer_name]))
	pass


func request_pattern(_position: Vector2, _composer_var : Dictionary) -> Array:
	var pattern_packs : Array = [
		{
			"direction" : Vector2.RIGHT,
			"position" : _position,
			"rotation" : 0.0,
		}
	]

	for pattern_component in get_children():
		if pattern_component is not ProjectilePatternComponent: continue
		if !pattern_component.active: continue
		pattern_packs = pattern_component.process_pattern(pattern_packs, _composer_var)
	
	pattern_composed.emit(pattern_packs)

	return pattern_packs
