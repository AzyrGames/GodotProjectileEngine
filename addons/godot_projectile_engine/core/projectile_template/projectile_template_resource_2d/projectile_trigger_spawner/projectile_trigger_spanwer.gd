extends Node2D
class_name ProjectileTriggerSpawner2D

@export var active : bool = false:
	set(value):
		active = value
		if value:
			connect_bullet_trigger()
		else:
			disconnect_bullet_trigger()

@export var trigger_name : String = ""
@export var is_instance : bool = false 
@export var bullet_spawner_node : BulletSpawner2D
@export var bullet_spawner_scene : String = ""

var is_connected : bool = false

func _ready() -> void:
	if active:
		connect_bullet_trigger()

func _exit_tree() -> void:
	disconnect_bullet_trigger()

func connect_bullet_trigger() -> void:
	if trigger_name.is_empty() or is_connected:
		return
	
	# Connect to both signals for compatibility with both systems
	if not ProjectileEngine.bullet_trigger_activated.is_connected(_on_bullet_trigger):
		ProjectileEngine.bullet_trigger_activated.connect(_on_bullet_trigger)
	
	if not ProjectileEngine.projectile_trigger_activated.is_connected(_on_projectile_trigger):
		ProjectileEngine.projectile_trigger_activated.connect(_on_projectile_trigger)
	
	is_connected = true

func disconnect_bullet_trigger() -> void:
	if not is_connected:
		return
	
	if ProjectileEngine.bullet_trigger_activated.is_connected(_on_bullet_trigger):
		ProjectileEngine.bullet_trigger_activated.disconnect(_on_bullet_trigger)
	
	if ProjectileEngine.projectile_trigger_activated.is_connected(_on_projectile_trigger):
		ProjectileEngine.projectile_trigger_activated.disconnect(_on_projectile_trigger)
	
	is_connected = false

func _on_bullet_trigger(_trigger_name: String, _bullet_instance: ProjectileInstance2D) -> void:
	if _trigger_name != trigger_name or not active:
		return
	
	if is_instance:
		_spawn_instance_at_position(_bullet_instance.global_position)
	else:
		_activate_spawner_node()

func _on_projectile_trigger(_trigger_name: String, _projectile_node: Node2D) -> void:
	if _trigger_name != trigger_name or not active:
		return
	
	var position = Vector2.ZERO
	if _projectile_node:
		position = _projectile_node.global_position
	
	if is_instance:
		_spawn_instance_at_position(position)
	else:
		_activate_spawner_node()

func _spawn_instance_at_position(position: Vector2) -> void:
	if bullet_spawner_scene.is_empty():
		push_warning("ProjectileTriggerSpawner2D: bullet_spawner_scene is empty")
		return
	
	var spawner_node = instance_node(bullet_spawner_scene)
	if spawner_node is BulletSpawner2D:
		spawner_node.global_position = position
		
		# Add to the projectile environment if available, otherwise to parent
		if ProjectileEngine.projectile_environment:
			ProjectileEngine.projectile_environment.add_child(spawner_node, true)
		else:
			get_parent().add_child(spawner_node, true)
	else:
		push_warning("ProjectileTriggerSpawner2D: Instantiated node is not a BulletSpawner2D")

func _activate_spawner_node() -> void:
	if not bullet_spawner_node:
		push_warning("ProjectileTriggerSpawner2D: bullet_spawner_node is null")
		return
	
	bullet_spawner_node.active = true

func instance_node(_file_path: String) -> Node:
	var _packed_scene : PackedScene = load(_file_path)
	if not _packed_scene:
		push_error("ProjectileTriggerSpawner2D: Scene not valid: " + _file_path)
		return null
	
	var _node_instance : Node = _packed_scene.instantiate()
	if not _node_instance:
		push_error("ProjectileTriggerSpawner2D: Node instantiation failed: " + _file_path)
		return null
	
	return _node_instance
