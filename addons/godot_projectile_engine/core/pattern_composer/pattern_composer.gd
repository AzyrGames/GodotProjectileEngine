extends Node
class_name PatternComposer2D

signal pattern_composed(_pattern_composer_pack: Dictionary)

@export var composer_name: String = "":
	set(value):
		if value == composer_name: return
		_register_pattern_composer(composer_name)
		composer_name = value

## Hold data base on PatternComposerContext
var pattern_composer_context_data: Dictionary

var _new_pattern_composer_pack: Array[PatternComposerData]
var _new_composer_data: PatternComposerData
var _init_pattern_composer_data: PatternComposerData

var _use_projectile_spawn_marker: bool = false

func _enter_tree() -> void:
	_register_pattern_composer(composer_name)
	pass


func _exit_tree() -> void:
	_deregister_pattern_composer(composer_name)
	pass


func _register_pattern_composer(_composer_name: String) -> void:
	if _composer_name == "": return
	_deregister_pattern_composer(_composer_name)
	if ProjectileEngine.pattern_composer_nodes.has(_composer_name):
		print_debug("Composer name: ", _composer_name, " is existed: ", ProjectileEngine.pattern_composer_nodes.get(_composer_name))
		return
	ProjectileEngine.pattern_composer_nodes.get_or_add(_composer_name, self)
	pass


func _deregister_pattern_composer(_composer_name: String) -> void:
	if _composer_name == "": return
	ProjectileEngine.pattern_composer_nodes.erase(_composer_name)
	pass


func _physics_process(delta: float) -> void:
	update()


## Take a request pattern to process thorugh Pattern Composer Component to
## return a new Array[PatternComposerData][br]
## Each request need a [pattern_composer_context] that is unique from the [ProjectileSpawner2D]
## or the requester
func request_pattern(_pattern_composer_context: PatternComposerContext) -> Array:
	# Init new PatternComposerContext slot in pattern composer data if not exist
	if !pattern_composer_context_data.has(_pattern_composer_context):
		pattern_composer_context_data[_pattern_composer_context] = [] as Array[PatternComposerData]

	if check_using_projecitle_spawn_maker(_pattern_composer_context):
		update_projectile_spawn_makers(_pattern_composer_context)
	else:
		update_single_spawner(_pattern_composer_context)

	get_pattern(_pattern_composer_context)

	return _new_pattern_composer_pack

func get_pattern(_pattern_composer_context: PatternComposerContext) -> void:
	_new_pattern_composer_pack = pattern_composer_context_data.get(_pattern_composer_context)
	## Process Pattern composer component
	for pattern_component in get_children():
		if pattern_component is not PatternComposerComponent: continue
		if !pattern_component.active: continue
		_new_pattern_composer_pack = pattern_component.process_pattern(_new_pattern_composer_pack)
	pass

## Check if using marker and atleast one of the marker is active
func check_using_projecitle_spawn_maker(_pattern_composer_context: PatternComposerContext) -> bool:
	if _pattern_composer_context.use_spawn_markers and _pattern_composer_context.projectile_spawn_markers.size() > 0:
		for _projectile_spawn_marker in _pattern_composer_context.projectile_spawn_markers:
			if _projectile_spawn_marker.active:
				return true
	return false
	pass


func update_single_spawner(_pattern_composer_context: PatternComposerContext) -> void:
	# Warning that use spawn maker but no active ProjectileSpawnMarker2D was found
	if _pattern_composer_context.use_spawn_markers:
		push_warning("No active ProjectileSpawnMarker2D was found! Fallback to use ProjectileSpawner2D position")
	var _pattern_composer_data: Array[PatternComposerData] = pattern_composer_context_data.get(_pattern_composer_context)

	# Remove the projectile_spawn_marker data
	clean_pattern_composer_data(_pattern_composer_data, true)

	if _pattern_composer_data.size() <= 0:
		_new_composer_data = PatternComposerData.new()
		_new_composer_data.position = _pattern_composer_context.projectile_spawner.global_position
		_pattern_composer_data.append(_new_composer_data)
		pattern_composer_context_data[_pattern_composer_context] = _pattern_composer_data

	elif _pattern_composer_context.projectile_spawner.global_position != _pattern_composer_data[0].position:
		_pattern_composer_data[0].position = _pattern_composer_context.projectile_spawner.global_position
	pass

func update_projectile_spawn_makers(_pattern_composer_context: PatternComposerContext) -> void:
	# Get the 
	var _pattern_composer_data: Array = pattern_composer_context_data.get(_pattern_composer_context)

	# Remove the projectile_spawn_marker data if it null
	clean_pattern_composer_data(_pattern_composer_data, false)

	if _pattern_composer_data.size() <= 0:
		# Create new PatternComposerData for each PatternSpawnerMarker2D
		for _projectile_spawn_marker in _pattern_composer_context.projectile_spawn_markers:
			if !_projectile_spawn_marker.active:
				continue

			_new_composer_data = PatternComposerData.new()
			_new_composer_data.projectile_spawn_marker = _projectile_spawn_marker
			_new_composer_data.direction = _projectile_spawn_marker.init_direction

			if _projectile_spawn_marker.use_global_position:
				_new_composer_data.position = _projectile_spawn_marker.global_position
			else:
				_new_composer_data.position = _projectile_spawn_marker.position

			_pattern_composer_data.append(_new_composer_data)
	else:
		for _composer_data in _pattern_composer_data:
			# Update Direction and Position if changed
			if _composer_data.direction != _composer_data.projectile_spawn_marker.init_direction:
				_composer_data.direction = _composer_data.projectile_spawn_marker.init_direction

			if _composer_data.projectile_spawn_marker.use_global_position:
				if _composer_data.position != _composer_data.projectile_spawn_marker.global_position:
					_composer_data.position = _composer_data.projectile_spawn_marker.global_position
			else:
				if _composer_data.position != _composer_data.projectile_spawn_marker.position:
					_composer_data.position = _composer_data.projectile_spawn_marker.position


func clean_pattern_composer_data(_pattern_composer_data: Array, _is_null: bool) -> void:
	var _erase_list: Array = []
	for _composer_data in _pattern_composer_data:
		if is_instance_valid(_composer_data.projectile_spawn_marker) == _is_null:
			_erase_list.append(_composer_data)
	if _erase_list.size() > 0:
		for thing in _erase_list:
			_pattern_composer_data.erase(thing)
	pass


## Update Child Pattern Composer Components
func update() -> void:
	var _update_pattern_composer_pack: Array[PatternComposerData]
	for _composer_data_array: Array[PatternComposerData] in pattern_composer_context_data.values():
		_update_pattern_composer_pack.append_array(_composer_data_array)
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
