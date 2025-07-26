extends Node
class_name PatternComposer2D

signal pattern_composed(_pattern_composer_pack: Dictionary)

@export var composer_name : String = "":
	set(value):
		if value == composer_name: return
		_register_pattern_composer(composer_name)
		composer_name = value

var pattern_composer_pack : Array[PatternComposerData]
var pattern_composer_dict : Dictionary

var _new_pattern_composer_pack : Array[PatternComposerData]
var _new_composer_data : PatternComposerData
var _init_comopser_data : PatternComposerData


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


func _physics_process(delta: float) -> void:
	update()


## Take a request pattern to process thorugh Pattern Composer Component to
## return a new Array[PatternComposerData]
func request_pattern(_pattern_composer_context : PatternComposerContext) -> Array:
	## Init pattern composer pack
	_init_comopser_data = PatternComposerData.new()
	pattern_composer_pack.clear()

	## Check and update spawn locations
	if _pattern_composer_context.use_spawn_markers and _pattern_composer_context.projectile_spawn_makers.size() > 0:
		for _key in pattern_composer_dict.keys():
			if _key is ProjectileSpawner2D:
				pattern_composer_dict.erase(_key)
		for _projectile_spawn_maker in _pattern_composer_context.projectile_spawn_makers:
			if !_projectile_spawn_maker.active:
				continue
			if pattern_composer_dict.has(_projectile_spawn_maker):
				pattern_composer_pack.append(pattern_composer_dict.get(_projectile_spawn_maker))
				continue
			## Setup new PatternComposerData for spawn marker
			_new_composer_data = _init_comopser_data.duplicate()
			_new_composer_data.base_direction = _projectile_spawn_maker.init_direction
			_new_composer_data.direction = _projectile_spawn_maker.init_direction
			pattern_composer_dict.get_or_add(_projectile_spawn_maker, _new_composer_data)
			pattern_composer_pack.append(_new_composer_data)
	else:
		for _key in pattern_composer_dict.keys():
			if _key is ProjectileSpawnMarker2D:
				pattern_composer_dict.erase(_key)
		if pattern_composer_dict.has(_pattern_composer_context.projectile_spawner):
			pattern_composer_pack.append(pattern_composer_dict.get(_pattern_composer_context.projectile_spawner))
		else:
			pattern_composer_dict.get_or_add(_pattern_composer_context.projectile_spawner, _init_comopser_data)
			pattern_composer_pack.append(_init_comopser_data)

	## Update spawn position
	if _pattern_composer_context.use_spawn_markers and pattern_composer_dict.values().size() > 0:
		for _projectile_spawn_maker in _pattern_composer_context.projectile_spawn_makers:
			if _projectile_spawn_maker.use_global_position:
				pattern_composer_dict.get(_projectile_spawn_maker).set("position", _projectile_spawn_maker.global_position)
			else:
				pattern_composer_dict.get(_projectile_spawn_maker).set("position", _projectile_spawn_maker.position)
	else:
		for pattern_composer_data : PatternComposerData in pattern_composer_dict.values():
			pattern_composer_data.position = _pattern_composer_context.position

	_new_pattern_composer_pack = pattern_composer_pack

	for pattern_component in get_children():
		if pattern_component is not PatternComposerComponent: continue
		if !pattern_component.active: continue
		_new_pattern_composer_pack = pattern_component.process_pattern(_new_pattern_composer_pack, _pattern_composer_context)
	return _new_pattern_composer_pack

## Update Child Pattern Composer Components
func update() -> void:
	var _update_pattern_composer_pack : Array[PatternComposerData]
	for _composer_data: PatternComposerData in pattern_composer_dict.values():
		_update_pattern_composer_pack.append(_composer_data)
	for pattern_component in get_children():
		if pattern_component is not PatternComposerComponent: continue
		if !pattern_component.active: continue
		pattern_component.update(_update_pattern_composer_pack)
	pass

func tick() -> void:
	for pattern_component in get_children():
		if pattern_component is not PatternComposerComponent: continue
		if !pattern_component.active: continue
		pattern_component.tick()
	pass
