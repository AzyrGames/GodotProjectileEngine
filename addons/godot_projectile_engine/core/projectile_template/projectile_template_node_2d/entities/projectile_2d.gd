extends Area2D
class_name Projectile2D

func apply_pattern_pack(_pattern_pack: Dictionary) -> void:

	# print(_pattern_pack)

	if has_meta("projectile_component_position") and _pattern_pack.has("position"):
		get_meta("projectile_component_position").position = _pattern_pack.get("position")

	if has_meta("projectile_component_direction") and _pattern_pack.has("direction"):
		get_meta("projectile_component_direction").force_apply_value(_pattern_pack.get("direction"))

	pass