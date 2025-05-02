extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BulletHell.bullet_trigger_activated.connect(say_hello)
	pass # Replace with function body.

func say_hello(bullet_instance : BulletInstance2D) -> void:
	pass