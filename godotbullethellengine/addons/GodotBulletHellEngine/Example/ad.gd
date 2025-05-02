extends Node2D

@onready var bullet_spawner_2d2: PackedScene = preload("res://Testing/TriggerNode.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BulletHell.bullet_trigger_activated.connect(_on_bullet_triggered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bullet_triggered(bullet_instance: BulletInstance2D) -> void:
	var new_spawner : Node2D = bullet_spawner_2d2.instantiate()
	new_spawner.position = bullet_instance.global_position
	# new_spawner.active = true
	add_child(new_spawner, true)
	pass