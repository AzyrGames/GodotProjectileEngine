extends ProjectileBehaviorScale
class_name ProjectileScaleVectorAccelerate

## Behavior that applies constant acceleration to projectile speed.
##
## Gradually increases projectile speed from its initial value up to a maximum speed,
## using a constant acceleration rate. The acceleration is applied each physics frame.
## This behavior overrides (replaces) the current speed value.

## Acceleration rate in units per second squared (how quickly speed increases)

@export var scale_x_accel_speed: float = 1.0
@export var scale_y_accel_speed: float = 1.0
## Maximum speed the projectile can reach (in units per second)
@export var max_scale_x : float = 3.0
@export var max_scale_y : float = 3.0

var _scale_x : float
var _scale_y : float


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA
	]

## Processes speed behavior by applying acceleration
func process_behavior(_value: Vector2, _context: Dictionary) -> Vector2:
	if !_context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA): return _value

	if _value == Vector2(max_scale_x, max_scale_y):
		return _value

	# Calculate new speed using frame-rate independent acceleration
	var delta := _context.get(ProjectileEngine.BehaviorContext.PHYSICS_DELTA) as float
	_scale_x = move_toward(_value.x, max_scale_x, scale_x_accel_speed * delta)
	_scale_y = move_toward(_value.y, max_scale_y, scale_y_accel_speed * delta)

	return Vector2(_scale_x, _scale_y)
