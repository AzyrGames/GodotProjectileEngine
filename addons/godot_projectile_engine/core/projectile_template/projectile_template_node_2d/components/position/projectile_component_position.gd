extends ProjectileComponent
class_name ProjectileComponentPosition

@export var position : Vector2

@export var projectile_speed : ProjectileComponentSpeed
@export var projectile_direction : ProjectileComponentDirection

## More accurate speed by using [param ProjectileComponentDirection.raw_direction]
@export var use_raw_direction_for_speed : bool = true

func get_component_name() -> StringName:
	return "projectile_component_position"

var velocity : Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	var _final_speed := projectile_speed.speed
	if use_raw_direction_for_speed:
		_final_speed *= projectile_direction.get_raw_direction().length()

	var _final_direction := projectile_direction.get_direction()
	
	velocity = _final_speed * _final_direction * delta
	position += velocity
	pass
