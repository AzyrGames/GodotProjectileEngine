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


func process_behavior(_value, _context: Dictionary) -> bool:
	if not active:
		return false

	var _life_time_second : float = _context.get(ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND, 0.0)
	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE, [])
	
	# Initialize trigger count if not present

	if _variable_array.size() == 0:
		_variable_array.append(0)  # trigger_count
		_variable_array.append(false)  # is_triggered

	# if triggered return
	if _variable_array[1]:
		return false

	if one_shot:
		# For one-shot triggers, trigger once when time is reached
		_should_trigger = _life_time_second >= trigger_time
	else:
		# For repeating triggers, trigger every trigger_time seconds
		if _life_time_second >= trigger_time * (_variable_array[0] + 1):
			_variable_array[0] = _variable_array[0] + 1
			_should_trigger = true
		else:
			_should_trigger = false

	if _should_trigger:
		if one_shot:
			_variable_array[1] = true
		return true

	return false
