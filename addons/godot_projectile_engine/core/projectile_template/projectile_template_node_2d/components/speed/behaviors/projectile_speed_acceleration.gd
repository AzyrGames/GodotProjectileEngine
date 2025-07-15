extends ProjectileBehaviorSpeed
class_name ProjectileSpeedAcceleration

## Behavior that applies constant acceleration to projectile speed.
##
## Gradually increases projectile speed from current speed to a maximum speed,
## using a constant acceleration rate. The acceleration is applied each physics frame.
## This speed behavior overrides (replaces) the current speed value.

## Acceleration rate in units per second squared (how quickly speed increases)
@export var acceleration_speed: float = 10.0
## Maximum speed the projectile can reach (in units per second)
@export var max_speed : float = 100.0

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA
	]


## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	var _physics_delta : float
	if _context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
		_physics_delta = _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)

	_speed_behavior_values["speed_overwrite"] = move_toward(_value, max_speed, acceleration_speed * _physics_delta)
	return _speed_behavior_values
