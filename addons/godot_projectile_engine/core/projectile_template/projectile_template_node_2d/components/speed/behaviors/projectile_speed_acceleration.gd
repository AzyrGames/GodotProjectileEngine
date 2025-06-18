extends ProjectileBehaviorSpeed
class_name ProjectileSpeedAcceleration

## Accelerate speed value from initial speed to max speed by acceleration_speed.
## This behavior will repleace current speed value

@export var acceleration_speed: float = 10.0
@export var max_speed : float = 500.0

func behavior_context_request() -> Array[ProjectileEngine.BehviorContext]:
	return [
		ProjectileEngine.BehviorContext.PHYSICS_DELTA
		]
	pass

func process_behavior(_value: float, _context: Dictionary) -> float:
	if _context.has(ProjectileEngine.BehviorContext.PHYSICS_DELTA):
		return move_toward(_value, max_speed, acceleration_speed * _context.get(ProjectileEngine.BehviorContext.PHYSICS_DELTA))
	return _value

