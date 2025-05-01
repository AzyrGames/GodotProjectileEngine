extends BulletSpawner2D

@onready var marker_2d: Marker2D = $Marker2D

func _ready() -> void:
	BulletHell.bullet_trigger_activated.connect(say_hello)
	pass # Replace with function body.

func say_hello(bullet_instance : BulletInstance2D) -> void:
	active = true
	# print(bullet_instance)
	# print(bullet_instance.global_position)
	marker_2d.global_position = bullet_instance.global_position
	pass
