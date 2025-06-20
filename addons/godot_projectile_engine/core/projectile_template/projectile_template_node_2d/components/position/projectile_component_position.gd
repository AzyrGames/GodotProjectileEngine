extends ProjectileComponent
class_name ProjectileComponentPosition

@export var position : Vector2

@export var projectile_speed : ProjectileComponentSpeed
@export var projectile_direction : ProjectileComponentDirection

func get_component_name() -> StringName:
	return "projectile_component_position"

var velocity : Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	velocity = projectile_speed.speed * projectile_direction.direction * projectile_direction.raw_direction.length() * delta
	position += velocity
	pass
