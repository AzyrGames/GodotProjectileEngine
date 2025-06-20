extends ProjectileBehaviorDirection
class_name ProjectileDirectionCurve2D

## Curve2D resource defining the direction path
@export var curve_2d: Curve2D
@export var curve_strenght : float = 0.5
## What value to use for the curve sampling (time/distance/etc)
@export var direction_curve_sample_method: SampleMethod = SampleMethod.LIFE_DISTANCE

## How the curve result modifies direction (add/override)
@export var direction_modify_method: DirectionModifyMethod = DirectionModifyMethod.OVERRIDE



## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.LIFE_DISTANCE,

	]

func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE
	]

func _init() -> void:
	if !curve_2d: return
	pass

## Processes direction behavior by sampling the curve
func process_behavior(_value: Vector2, _context: Dictionary) -> Array:
	if curve_2d == null:
		return [_value]
		
	if not _context.has(ProjectileEngine.BehaviorContext.LIFE_DISTANCE):
		return [_value]
	


	var life_distance: float = _context[ProjectileEngine.BehaviorContext.LIFE_DISTANCE]
	# curve_2d

	if _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE).size() == 0:
		_context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE).append(curve_2d.sample_baked(0.0))
		_context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE].append(0.0)
		# _context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE].append(Vector2.ZERO)

	# print("life distance: ", life_distance)

	var _next_curve_position: Vector2 = curve_2d.sample_baked(life_distance)
	var _new_direction : Vector2
	## last position is not the same so the direction == vector2.zero
	if _context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE][0] != _next_curve_position:
		_new_direction = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)[0].direction_to(_next_curve_position)
		print("old: ", _context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE][0])
		print("new: ", _next_curve_position)
		print(_new_direction)
		_new_direction = _new_direction
		_context[ProjectileEngine.BehaviorContext.ARRAY_VARIABLE][0] = _next_curve_position


	match direction_modify_method:
		## Yes, also need to track track every behaviors that modify the direction but....
		DirectionModifyMethod.ROTATION:
			return [_value, _new_direction.angle()]
			pass
		# Later ha, to complicated, need to track every behaviors that modify the addition.
		DirectionModifyMethod.ADDTITION:
			if _new_direction == Vector2.ZERO: 
				return [_value]
			return [_value, 0.0, _new_direction * curve_strenght]
			pass
		DirectionModifyMethod.OVERRIDE:
			return [_new_direction]
		_:
			[_value]
	
	return [_value]
