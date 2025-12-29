extends ProjectileBehaviorSpeed
class_name ProjectileSpeedAcceleration

## Behavior that applies constant acceleration to projectile speed.
##
## Gradually increases projectile speed from current speed to a maximum speed,
## using a constant acceleration rate. The acceleration is applied each physics frame.

@export var acceleration_speed: float = 20.0
@export var max_speed : float = 200.0

## Processes speed behavior by applying acceleration

func process_behavior(_active_p_instances: Array[ProjectileInstance2D], _delta: float) -> void:
	for _active_p_instance in _active_p_instances:
		_active_p_instance.last_speed = _active_p_instance.speed
		if _active_p_instance.speed >= max_speed: 
			continue
		_active_p_instance.speed = move_toward(
		_active_p_instance.speed, max_speed, acceleration_speed * _delta
		)
	pass