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


func process_behavior(_value, _context: Dictionary) -> bool:
	if not active:
		return false

	var _life_distance = _context.get(ProjectileEngine.BehaviorContext.LIFE_DISTANCE, 0.0)
	
	var _variable_array: Array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
	var _behavior_variable_trigger : BehaviorVariableTrigger

	for _variable in _variable_array:
		if _variable is BehaviorVariableTrigger:
			if !_variable.is_processed:
				_behavior_variable_trigger = _variable
	if _behavior_variable_trigger == null:
		_behavior_variable_trigger = BehaviorVariableTrigger.new()
		_variable_array.append(_behavior_variable_trigger)
	
	_behavior_variable_trigger.is_processed = true


	# Initialize trigger count if not present

	if _variable_array.size() == 0:
		_variable_array.append(0)  # trigger_count
		_variable_array.append(false)  # is_triggered

	if _behavior_variable_trigger.is_triggered:
		return false
	
	if one_shot:
		# For one-shot triggers, trigger once when distance is reached
		_should_trigger = _life_distance >= trigger_distance
	else:
		# For repeating triggers, trigger every trigger_distance units
		if _life_distance >= trigger_distance * (_behavior_variable_trigger.trigger_count + 1):
			_behavior_variable_trigger.trigger_count = _behavior_variable_trigger.trigger_count + 1
			_should_trigger = true
		else:
			_should_trigger = false

	if _should_trigger:
		if one_shot:
			_behavior_variable_trigger.is_triggered = true
		return true

	return false