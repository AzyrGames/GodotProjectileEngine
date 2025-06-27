extends Node
class_name PatternComposer2D

signal pattern_composed(_pattern_composer_pack: Dictionary)

@export var composer_name : String = "":
	set(value):
		if value == composer_name: return
		_register_pattern_composer(composer_name)
		composer_name = value

var pattern_composer_pack : Array[PatternComposerData]

func _enter_tree() -> void:
	_register_pattern_composer(composer_name)
	pass

func _exit_tree() -> void:
	_deregister_pattern_composer(composer_name)
	pass

func _register_pattern_composer(_composer_name: String) -> void:
	if _composer_name == "": return
	_deregister_pattern_composer(_composer_name)
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


func request_pattern(_pattern_composer_context : PatternComposerContext) -> Array:
	pattern_composer_pack  = [PatternComposerData.new()]

	for pattern_component in get_children():
		if pattern_component is not PatternComposerComponent: continue
		if !pattern_component.active: continue
		pattern_composer_pack = pattern_component.process_pattern(pattern_composer_pack, _pattern_composer_context)
	
	pattern_composed.emit(pattern_composer_pack)
	return pattern_composer_pack
