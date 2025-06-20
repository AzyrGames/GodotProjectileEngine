extends ProjectileComponent
class_name ProjectileComponentPosition

@export var position : Vector2

@export var projectile_speed : ProjectileComponentSpeed
@export var projectile_direction : ProjectileComponentDirection

func get_component_name() -> StringName:
	return "projectile_component_position"

var velocity : Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	# print(projectile_direction.direction, " -- ", projectile_direction.direction_addition)
	var _final_direction := (projectile_direction.direction + projectile_direction.direction_addition).normalized()
	# print('_final_direction - prerotation: ', _final_direction)
	var _final_speed := projectile_speed.speed * (
		projectile_direction.raw_direction + projectile_direction.direction_addition
		).length()
	if projectile_direction.direction_rotation != 0.0:
		_final_direction = _final_direction.rotated(projectile_direction.direction_rotation)

	velocity = _final_speed * _final_direction * delta
	position += velocity
	pass
