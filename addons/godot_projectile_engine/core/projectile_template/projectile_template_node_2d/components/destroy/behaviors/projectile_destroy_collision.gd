extends ProjectileBehaviorDestroy
class_name ProjectileDestroyCollision

## Collision-based destroy behavior that destroys projectiles when collide with object

## Destroy when projectile collide with an area
@export var destroy_on_area_collide: bool = true

## Destroy when projectile collide with a body
@export var destroy_on_body_collide: bool = true

## Wait for piercing is done before destroy
@export var wait_projectile_piercing : bool = false
@export var wait_projectile_bouncing : bool = false
var _behavior_variable_piercing : BehaviorVariablePiercing
var _behavior_variable_bouncing : BehaviorVariableBouncingReflect

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER
	]

func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE
	]


## Processes collision-based destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:

	if !destroy_on_area_collide and !destroy_on_body_collide:
		return false

	if not _context.has(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER):
		return false

	if !_context.has(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE):
		return false

	var behavior_owner = _context.get(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER)
	if not behavior_owner:
		return false
	if behavior_owner is Projectile2D:
		if destroy_on_area_collide:
			if behavior_owner.has_overlapping_areas():
				for _overlap_area in behavior_owner.get_overlapping_areas():
					if not _overlap_area.collision_layer & behavior_owner.collision_mask:
						continue
					if wait_projectile_piercing:
						if _behavior_variable_piercing:
							var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
							if _variable_array.size() <= 0:
								_behavior_variable_piercing = null
							for _variable in _variable_array:
								if _variable is BehaviorVariablePiercing:
									_behavior_variable_piercing = _variable
									break
								_behavior_variable_piercing = null
						if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
							return true
						return false
					elif wait_projectile_bouncing:
						if _behavior_variable_bouncing:
							var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
							if _variable_array.size() <= 0:
								_behavior_variable_bouncing = null
							for _variable in _variable_array:
								if _variable is BehaviorVariableBouncingReflect:
									_behavior_variable_bouncing = _variable
									break
								_behavior_variable_bouncing = null
						if _behavior_variable_bouncing.is_bouncing == false and _behavior_variable_bouncing.is_bouncing_done:
							return true
						return false
					else:
						return true
		if destroy_on_body_collide:
			if behavior_owner.has_overlapping_bodies():
				for _overlap_body in behavior_owner.get_overlapping_bodies():
					if not _overlap_body.collision_layer & behavior_owner.collision_mask:
						continue
					if wait_projectile_piercing:
						if _behavior_variable_piercing:
							var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
							if _variable_array.size() <= 0:
								_behavior_variable_piercing = null
							for _variable in _variable_array:
								if _variable is BehaviorVariablePiercing:
									_behavior_variable_piercing = _variable
									break
								_behavior_variable_piercing = null
						if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
							return true
						return false
					elif wait_projectile_bouncing:
						if _behavior_variable_bouncing:
							var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
							if _variable_array.size() <= 0:
								_behavior_variable_bouncing = null
							for _variable in _variable_array:
								if _variable is BehaviorVariableBouncingReflect:
									_behavior_variable_bouncing = _variable
									break
								_behavior_variable_bouncing = null
						if _behavior_variable_bouncing.is_bouncing == false and _behavior_variable_bouncing.is_bouncing_done:
							return true
						return false
					else:
						return true
						
	elif behavior_owner is ProjectileInstance2D:
		# print(behavior_owner.projectile_updater.has_overlapping_areas(behavior_owner.area_index))
		var _projectile_updater : ProjectileUpdater2D = behavior_owner.projectile_updater
		if destroy_on_area_collide:
			if _projectile_updater.has_overlapping_areas(behavior_owner.area_index):
				for _overlap_area in _projectile_updater.get_overlapping_areas(behavior_owner.area_index):
					if not _overlap_area.collision_layer & _projectile_updater.projectile_collision_mask:
						continue
					return true
					# if _behavior_variable_piercing:
					# 	if wait_projectile_piercing:
					# 		var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
					# 		if _variable_array.size() <= 0:
					# 			_behavior_variable_piercing = null
					# 		for _variable in _variable_array:
					# 			if _variable is BehaviorVariablePiercing:
					# 				_behavior_variable_piercing = _variable
					# 				break
					# 			_behavior_variable_piercing = null
					# 	if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
					# 		return true
					# 	return false
					# elif _behavior_variable_bouncing:
					# 	if wait_projectile_bouncing:
					# 		var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
					# 		if _variable_array.size() <= 0:
					# 			_behavior_variable_bouncing = null
					# 		for _variable in _variable_array:
					# 			if _variable is BehaviorVariableBouncingReflect:
					# 				_behavior_variable_bouncing = _variable
					# 				break
					# 			_behavior_variable_bouncing = null
					# 	if _behavior_variable_bouncing.is_bouncing == false and _behavior_variable_bouncing.is_bouncing_done:
					# 		return true
					# 	return false
					# else:
						
		if destroy_on_body_collide:
			if _projectile_updater.has_overlapping_bodies(behavior_owner.area_index):
				for _overlap_body in _projectile_updater.get_overlapping_bodies(behavior_owner.area_index):
					if not _overlap_body.collision_layer & _projectile_updater.projectile_collision_mask:
						continue
					return true
					# if _behavior_variable_piercing:
					# 	if wait_projectile_piercing:
					# 		var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
					# 		if _variable_array.size() <= 0:
					# 			_behavior_variable_piercing = null
					# 		for _variable in _variable_array:
					# 			if _variable is BehaviorVariablePiercing:
					# 				_behavior_variable_piercing = _variable
					# 				break
					# 			_behavior_variable_piercing = null
					# 	if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
					# 		return true
					# 	return false
					# elif _behavior_variable_bouncing:
					# 	if wait_projectile_bouncing:
					# 		var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
					# 		if _variable_array.size() <= 0:
					# 			_behavior_variable_bouncing = null
					# 		for _variable in _variable_array:
					# 			if _variable is BehaviorVariableBouncingReflect:
					# 				_behavior_variable_bouncing = _variable
					# 				break
					# 			_behavior_variable_bouncing = null
					# 	if _behavior_variable_bouncing.is_bouncing == false and _behavior_variable_bouncing.is_bouncing_done:
					# 		return true
					# 	return false
					# else:
					# 	return true
	
	return false
