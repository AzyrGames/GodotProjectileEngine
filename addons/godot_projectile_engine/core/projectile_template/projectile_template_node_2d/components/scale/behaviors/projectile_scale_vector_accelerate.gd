extends ProjectileBehaviorScale
class_name ProjectileScaleVectorAccelerate

## Behavior that applies constant acceleration to projectile speed.
##
## Gradually increases projectile speed from its initial value up to a maximum speed,
## using a constant acceleration rate. The acceleration is applied each physics frame.
## This behavior overrides (replaces) the current speed value.

## Acceleration rate in units per second squared (how quickly speed increases)

@export var scale_accel_speed: Vector2 = Vector2.ONE

@export var scale_max : Vector2 = Vector2.ONE

var _new_scale : Vector2 


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA
	]

## Processes speed behavior by applying acceleration
func process_behavior(_value: Vector2, _context: Dictionary) -> Vector2:
	if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA): return _value

	if _value == scale_max:
		return _value

	# Calculate new speed using frame-rate independent acceleration
	var delta := _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA) as float
	_new_scale.x = move_toward(_value.x, scale_max.x, scale_accel_speed.x * delta)
	_new_scale.y = move_toward(_value.y, scale_max.y, scale_accel_speed.y * delta)

	return _new_scale
