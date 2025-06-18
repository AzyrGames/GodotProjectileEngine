extends ProjectileBehaviorSpeed
class_name ProjectileSpeedAcceleration

## Behavior that applies constant acceleration to projectile speed.
##
## Gradually increases projectile speed from its initial value up to a maximum speed,
## using a constant acceleration rate. The acceleration is applied each physics frame.
## This behavior overrides (replaces) the current speed value.

## Acceleration rate in units per second squared (how quickly speed increases)
@export var acceleration_speed: float = 10.0
## Maximum speed the projectile can reach (in units per second)
@export var max_speed : float = 500.0

## Returns required context values for this behavior
func _behavior_context_request() -> Array[ProjectileEngine.BehviorContext]:
	return [
		ProjectileEngine.BehviorContext.PHYSICS_DELTA
	]

## Processes speed behavior by applying acceleration
func process_behavior(_value: float, _context: Dictionary) -> float:
	if _context.has(ProjectileEngine.BehviorContext.PHYSICS_DELTA):
		# Calculate new speed using frame-rate independent acceleration
		var delta := _context.get(ProjectileEngine.BehviorContext.PHYSICS_DELTA) as float
		return move_toward(_value, max_speed, acceleration_speed * delta)
	return _value
