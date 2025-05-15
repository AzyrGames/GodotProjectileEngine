extends Node2D
class_name BulletTriggerSpawner2D

@export var active : bool = false:
	set(value):
		if value:
			connect_bullet_trigger()
		else:
			disconnect_bullet_trigger()
		pass

@export var trigger_name : String


@export var is_instance : bool = false 

@export var bullet_spawner_node : BulletSpawner2D
@export var bullet_spawner_scene : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func connect_bullet_trigger() -> void:
	if trigger_name == null: return
	BulletHell.bullet_trigger_activated.connect(_on_bullet_trigger)
	pass

func disconnect_bullet_trigger() -> void:
	if trigger_name == null: return
	BulletHell.bullet_trigger_activated.disconnect(_on_bullet_trigger)
	pass


func _on_bullet_trigger(_trigger_name: String, _bullet_instance: BulletInstance2D) -> void:
	if _trigger_name != trigger_name: return
	# print("Trigger")
	if is_instance:
		var _node := instance_node(bullet_spawner_scene)
		if _node is BulletSpawner2D:
			_node.global_position = _bullet_instance.global_position
			add_child(_node, true)
	else:
		# bullet_spawner_node.ac
		bullet_spawner_node.active = true
		pass
	pass

func instance_node(_file_path: String) -> Node:
	var _packed_scene : PackedScene = load(_file_path)
	if !_packed_scene:
		print_debug("Scene not valid: " + _file_path)
		return null
	var _node_instance : Node = _packed_scene.instantiate()
	if !_node_instance:
		print_debug("Node not valid: " + _file_path)
		return null
	return _node_instance
