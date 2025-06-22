extends ProjectileComponent
class_name ProjectileComponentLifeDistance

## Projectile Life distance update everytime ProjectileComponentTransform2D is updated

@export var projectile_transform_2d : ProjectileComponentTransform2D

var life_distance : float = 0.0
var _last_transform_2d : Transform2D


func get_component_name() -> StringName:
	return "projectile_component_life_distance"

func _ready() -> void:
	if !projectile_transform_2d: return
	if !owner: return
	if owner is not Projectile2D: return
	owner = owner as Projectile2D
	_last_transform_2d = owner.get_transform()
	projectile_transform_2d.tranform_2d_updated.connect(_on_transform_2d_updated)

func update_life_distance(_transform_2d: Transform2D) -> void:
	life_distance += _last_transform_2d.get_origin().distance_to(_transform_2d.get_origin())
	_last_transform_2d = _transform_2d
	pass

func get_life_distance() -> float:
	return life_distance
	pass

func _on_transform_2d_updated(_transform_2d: Transform2D) -> void:
	update_life_distance(_transform_2d)
	pass
