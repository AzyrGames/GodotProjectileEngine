extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# body_entered.connect(_on_body_entered)
	# area_entered.connect(_on_area_entered)

	pass # Replace with function body.



func _on_body_entered(body:Node2D) -> void:
	print("body collided: ", body)
	pass # Replace with function body.


func _on_area_entered(area:Area2D) -> void:
	print("area collided: ", area)

	pass # Replace with function body.


func _on_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int) -> void:
	var _projectile_instance : ProjectileInstance2D = ProjectileEngine.get_projectile_instance(area_rid, area_shape_index)
	if !_projectile_instance:
		return
	# print(_projectile_instance.custom_data)
	pass # Replace with function body.
