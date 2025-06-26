extends Area2D
class_name Projectile2D

func apply_pattern_composer_data(_pattern_composer_data: PatternComposerData) -> void:
	# print(_pattern_composer_data)
	if has_meta("projectile_component_position"):
		get_meta("projectile_component_position").position = _pattern_composer_data.position

	if has_meta("projectile_component_direction"):
		get_meta("projectile_component_direction").direction = _pattern_composer_data.direction

	# if has_meta("projectile_component_rotation") and _pattern_composer_data.has("rotation"):
	# 	get_meta("projectile_component_rotation").rotation = _pattern_composer_data.get("rotation")


	# if has_meta("projectile_component_tranfrom_2d"):
	# 	get_meta("projectile_component_tranfrom_2d").update_projectile_transform_2d()

## Do not touch this
## Reset projectile components when reused
# func reset() -> void:
# 	if has_meta("projectile_component_piercing"):
# 		get_meta("projectile_component_piercing").reset()
	
# 	# Add reset calls for other components as needed
