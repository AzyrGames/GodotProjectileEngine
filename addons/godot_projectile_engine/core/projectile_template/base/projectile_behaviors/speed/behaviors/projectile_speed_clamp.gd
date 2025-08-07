extends ProjectileBehaviorSpeed
class_name ProjectileSpeedClamp

## Behavior that clamps projectile speed between minimum and maximum values.
##
## Ensures the projectile's speed stays within specified bounds by clamping
## the value between min_value and max_value each frame.

## Maximum allowed speed (in units per second)
@export var max_value : float = 300.0
## Minimum allowed speed (in units per second, can be negative for reverse movement)
@export var min_value : float = -300.0

## Clamps the speed value between min_value and max_value
func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	return {ProjectileEngine.SpeedModify.SPEED_CLAMP : Vector2(
		min(min_value, max_value),
		max(min_value, max_value)
		)}
