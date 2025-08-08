extends ProjectileBehaviorScale
class_name ProjectileScaleAccelerate

## Behavior that applies constant acceleration to projectile speed.
##
## Gradually increases projectile speed from its initial value up to a maximum speed,
## using a constant acceleration rate. The acceleration is applied each physics frame.
## This behavior overrides (replaces) the current speed value.

## Acceleration rate in units per second squared (how quickly speed increases)
@export var scale_acceleration_value: float = 1.0
## Maximum speed the projectile can reach (in units per second)
@export var scale_max : float = 2.0

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA
	]

## Processes speed behavior by applying acceleration
func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	if not _context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
		return behavior_values
	behavior_values[ProjectileEngine.ScaleModify.SCALE_OVERWRITE] = _value.move_toward(
		Vector2.ONE * scale_max,  
		scale_acceleration_value * 
		_context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA)
		)
	return behavior_values
