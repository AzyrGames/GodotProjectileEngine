extends ProjectileBehaviorTrigger
class_name ProjectileBehaviorTriggerSpeed

## Behavior that triggers based on projectile speed conditions.
##
## Activates when the projectile's speed meets the specified condition
## (below, above, or equal to a target speed within a threshold).
## If one_shot = false, triggers every time the condition is met (useful for state changes).

## Target speed value to compare against
@export var target_speed : float = 100.0
## Speed threshold for equality comparison
@export var speed_threshold : float = 10.0
## Trigger mode (below, above, or equal to target speed)
@export var trigger_mode : TriggerMode = TriggerMode.BELOW

enum TriggerMode {
	BELOW,
	ABOVE,
	EQUAL
}

## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.BASE_SPEED
	]

## Returns persistent context values for shared data
func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE
	]

## Checks if the trigger condition is met
func check_trigger_condition(_context: Dictionary) -> bool:
	var current_speed = _context.get(ProjectileEngine.BehaviorContext.BASE_SPEED, 0.0)
	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE, [])
	
	# Initialize previous condition state if not present
	if _variable_array.size() == 0:
		_variable_array.append(false)  # previous_condition_met
	
	var previous_condition_met: bool = _variable_array[0]
	
	var condition_met = false
	match trigger_mode:
		TriggerMode.BELOW:
			condition_met = current_speed < target_speed
		TriggerMode.ABOVE:
			condition_met = current_speed > target_speed
		TriggerMode.EQUAL:
			condition_met = abs(current_speed - target_speed) <= speed_threshold
	
	if one_shot:
		# For one-shot triggers, trigger once when condition is first met
		return condition_met
	else:
		# For repeating triggers, trigger on condition state changes (edge detection)
		var should_trigger = condition_met and not previous_condition_met
		_variable_array[0] = condition_met
		return should_trigger

## Reset the trigger state
func reset_trigger() -> void:
	super.reset_trigger()
	# Note: Array variables are reset by the component system
