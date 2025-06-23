extends ProjectileBehaviorTrigger
class_name ProjectileBehaviorTriggerDistance

## Behavior that triggers after traveling a specified distance.
##
## Activates when the projectile has traveled the specified distance from its spawn point.
## If one_shot = false, triggers repeatedly every trigger_distance units.

## Distance in units before trigger activates
@export var trigger_distance : float = 100.0

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_DISTANCE
	]

## Returns persistent context values for shared data
func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE
	]

## Checks if the trigger condition is met
func check_trigger_condition(_context: Dictionary) -> bool:
	var life_distance = _context.get(ProjectileEngine.BehaviorContext.LIFE_DISTANCE, 0.0)
	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE, [])
	
	# Initialize trigger count if not present
	if _variable_array.size() == 0:
		_variable_array.append(0)  # trigger_count
	
	var trigger_count: int = _variable_array[0]
	
	if one_shot:
		# For one-shot triggers, trigger once when distance is reached
		return life_distance >= trigger_distance
	else:
		# For repeating triggers, trigger every trigger_distance units
		var next_trigger_distance = trigger_distance * (trigger_count + 1)
		if life_distance >= next_trigger_distance:
			_variable_array[0] = trigger_count + 1
			return true
	
	return false

## Reset the trigger state
func reset_trigger() -> void:
	super.reset_trigger()
	# Note: Array variables are reset by the component system
