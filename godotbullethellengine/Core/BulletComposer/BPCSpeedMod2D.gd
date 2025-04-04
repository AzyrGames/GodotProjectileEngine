## Bullet Pattern Component Base

extends BPCBase
class_name BPCSpeedMod2D


@export var increase_step : float = 0.1
@export var start_value : float = 1.0


func process_pattern(pattern_packs: Array) -> Array:
	for i in range(len(pattern_packs)):
		pattern_packs[i].speed_mod = start_value + i * increase_step

	return pattern_packs

