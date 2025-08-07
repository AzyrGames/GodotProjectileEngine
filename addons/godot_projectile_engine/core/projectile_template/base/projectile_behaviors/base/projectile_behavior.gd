extends Resource
class_name ProjectileBehavior

## Base class for all projectile behaviors in the projectile engine.
##
## Provides core functionality and interface that all behavior implementations
## must follow. Behaviors modify projectile properties over time.

## Enum defining when the behavior should be sampled/processed
enum SampleMethod {
	## Samples behavior every projecitle life time in tick
	# LIFE_TIME_TICK,
	## Samples behavior every projecitle life time in second
	LIFE_TIME_SECOND,
	## Samples behavior based on projecitle life distance traveled
	LIFE_DISTANCE,
}

enum ProcessMode {
	PHYSICS,
	TICKS,
}

var behavior_values : Dictionary = {}

## Whether this behavior is currently active
@export var active : bool = true

## Requests additional context data needed by this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return []

func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return []

## Processes the behavior and returns modified values
func process_behavior(_value, _context):
	pass
