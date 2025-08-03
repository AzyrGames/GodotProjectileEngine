extends ProjectileBehaviorTrigger
class_name ProjectileBehaviorTriggerDistance

## Behavior that triggers after traveling a specified distance.
##
## Activates when the projectile has traveled the specified distance from its spawn point.

## Distance in units before trigger activates
@export var trigger_distance : float = 100.0

var _variable_array : Array
var _behavior_variable_trigger : BehaviorVariableTrigger
var _life_distance : float


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


func process_behavior(_value, _context: Dictionary) -> Dictionary:
	_variable_array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)

	# Set new instance variable array, if not it's will process the past variable
	if _variable_array.size() <= 0:
		_behavior_variable_trigger = null
	for _variable in _variable_array:
		if _variable is BehaviorVariableTrigger:
			if !_variable.is_processed:
				_behavior_variable_trigger = _variable
			break
		else:
			_behavior_variable_trigger = null

	if _behavior_variable_trigger == null:
		_behavior_variable_trigger = BehaviorVariableTrigger.new()
		_variable_array.append(_behavior_variable_trigger)

	_should_trigger = false
	_behavior_variable_trigger.is_processed = true

	if _behavior_variable_trigger.is_trigger_done:
		return {"is_trigger" : false}

	if _context.has(ProjectileEngine.BehaviorContext.LIFE_DISTANCE):
		_life_distance = _context.get(ProjectileEngine.BehaviorContext.LIFE_DISTANCE, 0.0)

	if trigger_repeat_count == 0:
		_trigger_behavior_values["is_trigger"] = false
		if destroy_when_done:
			_trigger_behavior_values["is_destroy"] = true
		_behavior_variable_trigger.is_trigger_done = true

	elif trigger_repeat_count < 0:
		_should_trigger = _life_distance >= trigger_distance * (_behavior_variable_trigger.trigger_count + 1)
		_trigger_behavior_values["is_trigger"] = _should_trigger
		if _should_trigger:
			_behavior_variable_trigger.trigger_count += 1

	elif trigger_repeat_count == 1:
		_trigger_behavior_values["is_trigger"] = _life_distance >= trigger_distance
		if destroy_when_done:
			_trigger_behavior_values["is_destroy"] = true
		_behavior_variable_trigger.is_trigger_done = true

	elif _behavior_variable_trigger.trigger_count < trigger_repeat_count:
		_should_trigger = _life_distance >= trigger_distance * (_behavior_variable_trigger.trigger_count + 1)
		_trigger_behavior_values["is_trigger"] = _should_trigger
		if _should_trigger:
			_behavior_variable_trigger.trigger_count += 1
	else:
		_behavior_variable_trigger.is_trigger_done = true
		_trigger_behavior_values["is_trigger"] = false
		if destroy_when_done:
			_trigger_behavior_values["is_destroy"] = true

	return _trigger_behavior_values
