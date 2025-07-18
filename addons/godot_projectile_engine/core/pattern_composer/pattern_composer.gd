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
	pass


func _deregister_pattern_composer(_composer_name: String) -> void:
	if _composer_name == "": return
	ProjectileEngine.projectile_composer_nodes.erase(_composer_name)
	pass


func request_pattern(_pattern_composer_context : PatternComposerContext) -> Array:
	## Init pattern composer pack
	var _init_comopser_data := PatternComposerData.new()
	if _pattern_composer_context.use_spawn_makers and _pattern_composer_context.projectile_spawn_makers.size() > 0:
		for _projectile_spawn_maker in _pattern_composer_context.projectile_spawn_makers:
			if !_projectile_spawn_maker.active:
				continue
			var _new_composer_data : PatternComposerData = _init_comopser_data.duplicate()
			if _projectile_spawn_maker.use_global_position:
				_new_composer_data.position = _projectile_spawn_maker.global_position
			else:
				_new_composer_data.position = _projectile_spawn_maker.position
			_new_composer_data.direction = _projectile_spawn_maker.init_direction
			pattern_composer_pack.append(_new_composer_data)
	else:
		_init_comopser_data.position = _pattern_composer_context.position
		pattern_composer_pack  = [_init_comopser_data]

	## Process through all Pattern Composer
	for pattern_component in get_children():
		if pattern_component is not PatternComposerComponent: continue
		if !pattern_component.active: continue
		pattern_composer_pack = pattern_component.process_pattern(pattern_composer_pack, _pattern_composer_context)
	
	pattern_composed.emit(pattern_composer_pack)
	return pattern_composer_pack
