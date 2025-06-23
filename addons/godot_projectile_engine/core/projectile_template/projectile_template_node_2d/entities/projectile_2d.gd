extends Area2D
class_name Projectile2D

func apply_pattern_pack(_pattern_pack: Dictionary) -> void:
	if has_meta("projectile_component_position") and _pattern_pack.has("position"):
		get_meta("projectile_component_position").position = _pattern_pack.get("position")

	if has_meta("projectile_component_direction") and _pattern_pack.has("direction"):
		get_meta("projectile_component_direction").direction = _pattern_pack.get("direction")

	if has_meta("projectile_component_rotation") and _pattern_pack.has("rotation"):
		get_meta("projectile_component_rotation").rotation = _pattern_pack.get("rotation")
	
	# Apply piercing properties if component exists
	if has_meta("projectile_component_piercing"):
		var piercing_component = get_meta("projectile_component_piercing")
		if _pattern_pack.has("piercing_count"):
			piercing_component.max_piercing_count = _pattern_pack.get("piercing_count")
		if _pattern_pack.has("max_piercing_count"):
			piercing_component.max_piercing_count = _pattern_pack.get("max_piercing_count")
		piercing_component.reset()

	if has_meta("projectile_component_tranfrom_2d"):
		get_meta("projectile_component_tranfrom_2d").update_projectile_transform_2d()

## Reset projectile components when reused
func reset() -> void:
	if has_meta("projectile_component_piercing"):
		get_meta("projectile_component_piercing").reset()
	
	# Add reset calls for other components as needed
