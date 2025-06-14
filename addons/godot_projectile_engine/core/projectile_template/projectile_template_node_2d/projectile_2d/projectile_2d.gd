extends Area2D
class_name Projectile2D

# ## Temponary variable
# @export var move_speed : float = 100
# var move_direction : Vector2

# var velocity : Vector2

# func _physics_process(delta: float) -> void:
# 	velocity = move_speed * move_direction * delta
# 	position += velocity
# 	pass


func apply_pattern_pack(_pattern_pack: Dictionary) -> void:

	print(_pattern_pack)

	if has_meta("projectile_component_position") and _pattern_pack.has("position"):
		get_meta("projectile_component_position").position = _pattern_pack.get("position")

	if has_meta("projectile_component_direction") and _pattern_pack.has("direction"):
		get_meta("projectile_component_direction").direction = _pattern_pack.get("direction")

	# if _pattern_pack.has("rotation"):
	# 	rotation = _pattern_pack.get("rotation")

	# if _pattern_pack.has("position"):
	# 	global_position = _pattern_pack.get("position")
	
	pass