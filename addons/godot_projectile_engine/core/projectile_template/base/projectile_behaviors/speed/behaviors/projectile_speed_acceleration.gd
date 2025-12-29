extends ProjectileBehaviorSpeed
class_name ProjectileSpeedAcceleration

## Behavior that applies constant acceleration to projectile speed.
##
## Gradually increases projectile speed from current speed to a maximum speed,
## using a constant acceleration rate. The acceleration is applied each physics frame.

@export var acceleration_speed: float = 20.0
@export var max_speed : float = 200.0

## Processes speed behavior by applying acceleration

func process_behavior(_values: Array, _delta: float) -> Array:
	var _new_values : Array = _values.duplicate()
	for _index in _new_values.size():
		if _new_values[_index] is not float: continue
		if _new_values[_index] >= max_speed: 
			continue
		_new_values[_index] = move_toward(
		_new_values[_index], max_speed, acceleration_speed * _delta
		)
	return _new_values