extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# body_entered.connect(_on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body:Node2D) -> void:
	print("Hello")
	pass # Replace with function body.


func _on_area_entered(area:Area2D) -> void:
	print("Hey")
	pass # Replace with function body.
