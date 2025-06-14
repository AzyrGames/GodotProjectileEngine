extends ProjectileComponent
class_name ProjectileComponentTransform2D

signal velocity_updated(_velocity: Vector2)
signal position_updated(_position_delta: Vector2)

@export_category("Position")
@export var projectile_speed : ProjectileComponentSpeed
@export var projectile_direction : ProjectileComponentDirection

@export_category("Rotation")
@export var projectile_rotation : ProjectileComponentDirection

@export_category("Scale")
@export var projectile_scale : ProjectileComponentDirection

## I hate skew, skew me
@export_category("Skew")
@export var projectile_skew : ProjectileComponentDirection


var velocity : Vector2
var position_delta : Vector2
var rotation_delta : float
var scale_delta : Vector2
var skew_delta : float


var _transform_2d : Transform2D

func _physics_process(delta: float) -> void:
	if !owner: return
	if owner is not Projectile2D: return
	owner = owner as Projectile2D
	
	velocity = projectile_speed.speed * projectile_direction.direction * delta
	velocity_updated.emit(velocity)
	position_delta = velocity
	rotation_delta = 2.0
	scale_delta = Vector2(0.001, 0.001)
	skew_delta = 0.0



	# _transform_2d = Transform2D(
	# 	owner.rotation + rotation_delta, 
	# 	owner.scale + scale_delta, 
	# 	owner.skew + skew_delta, 
	# 	owner.position + position_delta
	# 	)
	# owner.transform = _transform_2d
	# # owner.position += position_delta
	# # owner.rotation += rotation_delta
	# # owner.scale += scale_delta
	# # owner.skew += skew_delta


	# position_updated.emit(position_delta)
	pass
