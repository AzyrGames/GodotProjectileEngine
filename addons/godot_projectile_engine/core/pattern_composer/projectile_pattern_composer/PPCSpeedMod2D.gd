## Bullet Pattern Component Base

extends ProjectilePatternComponent
class_name PPCSpeedMod2D


@export var increase_step : float = 0.1
@export var start_value : float = 1.0


func process_pattern(pattern_packs: Array, _composer_var : Dictionary) -> Array:
	for i in range(len(pattern_packs)):
		if pattern_packs[i].has("speed_mod"):
			pattern_packs[i].speed_mod += start_value + i * increase_step
		else:
			pattern_packs[i].speed_mod = start_value + i * increase_step
	return pattern_packs
