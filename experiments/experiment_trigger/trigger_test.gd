extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProjectileEngine.projectile_instance_triggered.connect(test_trigger)
	pass # Replace with function body.


func test_trigger(trigger_name: String, projectile_instance: ProjectileInstance2D) -> void:
	print("Triggered: ", trigger_name)
	print("Projectile: ", projectile_instance)
	pass