extends Node
class_name PatternComposer2D

signal pattern_composed(_pattern_composer_pack: Dictionary)

@export var composer_name : String = "":
	set(value):
		if value == composer_name: return
		_register_pattern_composer(composer_name)
		composer_name = value

# var pattern_composer_pack : Array[PatternComposerData]
var pattern_composer_dict : Dictionary

var _new_pattern_composer_pack : Array[PatternComposerData]
var _new_composer_data : PatternComposerData
var _init_pattern_composer_data : PatternComposerData

var _user_projectile_spawn_marker : bool = false

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
	_init_pattern_composer_data = PatternComposerData.new()
	## Check if can using ProjectileSpawnMarker2Ds
	_user_projectile_spawn_marker = false
	if _pattern_composer_context.use_spawn_markers and _pattern_composer_context.projectile_spawn_makers.size() > 0:
		for _projectile_spawn_maker in _pattern_composer_context.projectile_spawn_makers:
			if _projectile_spawn_maker.active:
				_user_projectile_spawn_marker = true

	## Check and update spawn locations
	if _user_projectile_spawn_marker:
		## Remove ProjectileSpawner spawn position to prevent duplication
		for _key in pattern_composer_dict.keys():
			if _key is ProjectileSpawner2D:
				pattern_composer_dict.erase(_key)

		for _projectile_spawn_maker in _pattern_composer_context.projectile_spawn_makers:
			if !_projectile_spawn_maker.active:
				continue
			if !pattern_composer_dict.has(_projectile_spawn_maker):
				_new_composer_data = _init_pattern_composer_data.duplicate()
			pattern_composer_dict.get_or_add(_projectile_spawn_maker, _new_composer_data)
	else:
		if _pattern_composer_context.use_spawn_markers:
			push_warning("No active ProjectileSpawnMarker2D was found! Fallback to use ProjectileSpawner2D position")
		## Remove ProjectileSpawnMarker spawn position to prevent duplication
		for _key in pattern_composer_dict.keys():
			if _key is ProjectileSpawnMarker2D:
				pattern_composer_dict.erase(_key)
		pattern_composer_dict.get_or_add(_pattern_composer_context.projectile_spawner, _init_pattern_composer_data)
	## Get and update pattern composer data spawn position
	# var other_pattern_composer_pack : Array[PatternComposerData]
	_new_pattern_composer_pack = []
	for _spawn_node : Node in pattern_composer_dict.keys():
		if _spawn_node is ProjectileSpawnMarker2D:
			if _spawn_node.use_global_position:
				pattern_composer_dict.get(_spawn_node).set("position", _spawn_node.global_position)
			else:
				pattern_composer_dict.get(_spawn_node).set("position", _spawn_node.position)
		elif _spawn_node is ProjectileSpawner2D:
			pattern_composer_dict.get(_spawn_node).set("position", _spawn_node.global_position)
		_new_pattern_composer_pack.append(pattern_composer_dict.get(_spawn_node))
	## Process Pattern composer component
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
