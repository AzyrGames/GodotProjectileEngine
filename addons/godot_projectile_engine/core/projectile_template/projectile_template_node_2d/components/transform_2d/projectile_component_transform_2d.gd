extends ProjectileComponent
class_name ProjectileComponentTransform2D

signal tranform_2d_updated(_transform: Transform2D)

@export var projectile_position : ProjectileComponentPosition
@export var projectile_rotation : ProjectileComponentRotation
@export var projectile_scale : ProjectileComponentScale
## I hate skew, skew me
@export var projectile_skew : ProjectileComponentSkew


var velocity : Vector2
var position_delta : Vector2
var rotation_delta : float
var scale_delta : Vector2
var skew_delta : float


var _transform_2d : Transform2D

func get_component_name() -> StringName:
	return "projectile_component_transform_2d"

func _physics_process(delta: float) -> void:
	update_projectile_transform_2d()
	pass

func update_projectile_transform_2d() -> void:
	if !owner: return
	if owner is not Projectile2D: return
	owner = owner as Projectile2D

	owner.get_transform()

	_transform_2d = Transform2D(
		projectile_rotation.get_rotation(),
		projectile_scale.scale, 
		projectile_skew.skew,
		projectile_position.position 
		)

	owner.transform = _transform_2d
	tranform_2d_updated.emit(_transform_2d)
	pass
