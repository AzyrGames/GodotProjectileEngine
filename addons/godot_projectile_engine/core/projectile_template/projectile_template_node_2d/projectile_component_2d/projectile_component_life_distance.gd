extends ProjectileComponent
class_name ProjectileComponentLifeDistance

## Projectile Life Time update everytime ProjectileComponentUpdatePosition processed

@export var projectile_update_position : ProjectileComponentTransform2D

var current_life_distance : float = 0.0

func get_component_name() -> StringName:
	return "projectile_component_life_distance"

func _ready() -> void:
	if !projectile_update_position: return
	projectile_update_position.position_updated.connect(_on_position_updated)


func get_life_distance() -> float:
	return current_life_distance
	pass

func _on_position_updated(_position_delta: Vector2) -> void:
	current_life_distance += _position_delta.length()
	pass
