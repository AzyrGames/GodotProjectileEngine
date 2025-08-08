extends ProjectileBehaviorBouncing
class_name ProjectileBouncingReflect

## bouncing only work with body, NOT AREA

@export var bouncing_count : int = 3


func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER
	]

func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE
	]


var _variable_array : Array = []
var _should_bouncing : bool = false

var _behavior_variable_bouncing_reflect : BehaviorVariableBouncingReflect

func process_behavior(_value, _context: Dictionary) -> Dictionary:
	if bouncing_count <= 0:
		return {}

	if not _context.has(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER):
		return {}
	var _behavior_owner = _context.get(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER)
	if not _behavior_owner:
		return {}
	if !_context.has(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE):
		return {}
	_variable_array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
	if _variable_array.size() <= 0:
		_behavior_variable_bouncing_reflect = null
	for _variable in _variable_array:
		if _variable is BehaviorVariableBouncingReflect:
			if !_variable.is_processed:
				_behavior_variable_bouncing_reflect = _variable
				break
		else:
			_behavior_variable_bouncing_reflect = null
	if _behavior_variable_bouncing_reflect == null:
		_behavior_variable_bouncing_reflect = BehaviorVariableBouncingReflect.new()
		_variable_array.append(_behavior_variable_bouncing_reflect)

	_should_bouncing = false
	_bouncing_behavior_values = {}
	_behavior_variable_bouncing_reflect.is_processed = true

	if _behavior_variable_bouncing_reflect.is_bouncing == false and _behavior_variable_bouncing_reflect.is_bouncing_done:
		return {}

	if _behavior_variable_bouncing_reflect.is_bouncing_just_done:
		_behavior_variable_bouncing_reflect.is_bouncing_done = true
		_behavior_variable_bouncing_reflect.is_bouncing = false
		return {}

	var _new_direction : Vector2

	if _behavior_owner is Projectile2D:
		if _behavior_owner.has_overlapping_bodies():
			for _overlap_body  in _behavior_owner.get_overlapping_bodies():
				if _behavior_variable_bouncing_reflect.bounced_targets.has(_overlap_body):
					continue
				if not _overlap_body.collision_layer & _behavior_owner.collision_mask:
					continue

				var _collision_body = ProjectileEngine.projectile_environment.projectile_bouncing_helper
				_collision_body.transform = _behavior_owner.transform
				_collision_body.force_update_transform()
				var _collider = _collision_body.move_and_collide(Vector2.ZERO)
				if !_collider:
					return {}

				_new_direction = _behavior_owner.direction.reflect(_collider.get_normal()) * -1.0
				_bouncing_behavior_values["bounced_node"] = _overlap_body
				_bouncing_behavior_values["is_bouncing"] = _should_bouncing
				_bouncing_behavior_values[ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE] = _new_direction
				_behavior_variable_bouncing_reflect.is_bouncing = true
				_behavior_variable_bouncing_reflect.bounced_targets.append(_overlap_body)

				if bouncing_count == 1:
					_behavior_variable_bouncing_reflect.is_bouncing_just_done = true
				elif _behavior_variable_bouncing_reflect.current_bouncing_count < bouncing_count - 1:
					_behavior_variable_bouncing_reflect.current_bouncing_count += 1
				else:
					_behavior_variable_bouncing_reflect.is_bouncing_just_done = true

	if _behavior_owner is ProjectileInstance2D:
		var _projectile_updater : ProjectileUpdater2D = _behavior_owner.projectile_updater
		if _projectile_updater.has_overlapping_bodies(_behavior_owner.area_index):
			for _overlap_body  in _projectile_updater.get_overlapping_bodies(_behavior_owner.area_index):
				if _behavior_variable_bouncing_reflect.bounced_targets.has(_overlap_body):
					continue
				if not _overlap_body.collision_layer & _projectile_updater.projectile_collision_mask:
					continue

				var _collision_body = ProjectileEngine.projectile_environment.projectile_bouncing_helper
				_collision_body.transform = _behavior_owner.transform
				_collision_body.force_update_transform()
				var _collider = _collision_body.move_and_collide(Vector2.ZERO)
				if !_collider:
					return {}

				_new_direction = _behavior_owner.direction.reflect(_collider.get_normal()) * -1.0
				_bouncing_behavior_values["bounced_node"] = _overlap_body
				_bouncing_behavior_values["is_bouncing"] = _should_bouncing
				_bouncing_behavior_values[ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE] = _new_direction
				_behavior_variable_bouncing_reflect.is_bouncing = true
				_behavior_variable_bouncing_reflect.bounced_targets.append(_overlap_body)
				if bouncing_count == 1:
					_behavior_variable_bouncing_reflect.is_bouncing_just_done = true
				elif _behavior_variable_bouncing_reflect.current_bouncing_count < bouncing_count - 1:
					_behavior_variable_bouncing_reflect.current_bouncing_count += 1
				else:
					_behavior_variable_bouncing_reflect.is_bouncing_just_done = true

	return _bouncing_behavior_values
