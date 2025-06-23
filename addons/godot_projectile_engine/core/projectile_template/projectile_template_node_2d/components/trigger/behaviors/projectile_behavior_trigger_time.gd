extends ProjectileBehaviorTrigger
class_name ProjectileBehaviorTriggerTime

## Behavior that triggers after a specified time duration.
##
## Activates when the projectile has been alive for the specified time.
## If one_shot = false, triggers repeatedly every trigger_time seconds.

## Time duration in seconds before trigger activates
@export var trigger_time : float = 1.0

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND
	]

## Returns persistent context values for shared data
func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE
	]

## Checks if the trigger condition is met
func check_trigger_condition(_context: Dictionary) -> bool:
	var life_time_second = _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND, 0.0)
	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE, [])
	
	# Initialize trigger count if not present
	if _variable_array.size() == 0:
		_variable_array.append(0)  # trigger_count
	
	var trigger_count: int = _variable_array[0]
	
	if one_shot:
		# For one-shot triggers, trigger once when time is reached
		return life_time_second >= trigger_time
	else:
		# For repeating triggers, trigger every trigger_time seconds
		var next_trigger_time = trigger_time * (trigger_count + 1)
		if life_time_second >= next_trigger_time:
			_variable_array[0] = trigger_count + 1
			return true
	
	return false

## Reset the trigger state
func reset_trigger() -> void:
	super.reset_trigger()
	# Note: Array variables are reset by the component system
