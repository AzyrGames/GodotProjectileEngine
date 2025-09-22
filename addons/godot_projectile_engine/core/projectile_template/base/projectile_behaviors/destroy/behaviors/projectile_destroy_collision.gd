extends ProjectileBehaviorDestroy
class_name ProjectileDestroyCollision

## Collision-based destroy behavior that destroys projectiles when collide with object

## Destroy when projectile collide with an area
@export var destroy_on_area_collide: bool = true

## Destroy when projectile collide with a body
@export var destroy_on_body_collide: bool = true

## Wait for Piercing is done before destroy
@export var wait_projectile_piercing : bool = false
## Wait for Boucing is done before destroy
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

	if !_context.has(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER):
		return false

	if !_context.has(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE):
		return false

	var _behavior_owner = _context.get(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER)
	if !_behavior_owner:
		return false

	if _behavior_owner is Projectile2D:
		if !_behavior_owner.monitorable or !_behavior_owner.monitoring:
			return false
		if destroy_on_area_collide:
			if _behavior_owner.has_overlapping_areas():
				for _overlap_area in _behavior_owner.get_overlapping_areas():
					if not _overlap_area.collision_layer & _behavior_owner.collision_mask:
						continue
					if wait_projectile_piercing:
						var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
						if _variable_array.size() <= 0:
							_behavior_variable_piercing = null
							return false
						for _variable in _variable_array:
							if _variable is BehaviorVariablePiercing:
								_behavior_variable_piercing = _variable
								break
							_behavior_variable_piercing = null
						if !_behavior_variable_piercing:
							return false
						if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
							return true
						return false

					# if wait_projectile_bouncing:
					# 	var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
					# 	if _variable_array.size() <= 0:
					# 		_behavior_variable_bouncing = null
					# 		return false
					# 	for _variable in _variable_array:
					# 		if _variable is BehaviorVariableBouncingReflect:
					# 			_behavior_variable_bouncing = _variable
					# 			break
					# 		_behavior_variable_bouncing = null
					# 	if !_behavior_variable_bouncing:
					# 		return false
					# 	if _behavior_variable_bouncing.is_bouncing == false and _behavior_variable_bouncing.is_bouncing_done:
					# 		return true
					# 	return false

					return true
		if destroy_on_body_collide:
			if _behavior_owner.has_overlapping_bodies():
				for _overlap_body in _behavior_owner.get_overlapping_bodies():
					var _overlap_body_collision_layer : int = ProjectileEngine.get_collider_collision_layer(_overlap_body)
					if not _overlap_body_collision_layer & _behavior_owner.collision_mask:
						continue

					if wait_projectile_piercing:
						var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
						if _variable_array.size() <= 0:
							_behavior_variable_piercing = null
							return false
						for _variable in _variable_array:
							if _variable is BehaviorVariablePiercing:
								_behavior_variable_piercing = _variable
								break
							_behavior_variable_piercing = null
						if !_behavior_variable_piercing:
							return false
						if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
							return true
						return false

					if wait_projectile_bouncing:
						var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
						if _variable_array.size() <= 0:
							_behavior_variable_bouncing = null
							return false
						for _variable in _variable_array:
							if _variable is BehaviorVariableBouncingReflect:
								_behavior_variable_bouncing = _variable
								break
							_behavior_variable_bouncing = null
						if !_behavior_variable_bouncing:
							return false
						if _behavior_variable_bouncing.is_bouncing == false and _behavior_variable_bouncing.is_bouncing_done:
							return true
						return false
					return true

	elif _behavior_owner is ProjectileInstance2D:
		var _projectile_updater : ProjectileUpdater2D = _behavior_owner.projectile_updater
		if destroy_on_area_collide:
			if _projectile_updater.has_overlapping_areas(_behavior_owner.area_index):
				# print("ProjectileEngine ProjectileEngine: ", ProjectileEngine)
				for _overlap_area in _projectile_updater.get_overlapping_areas(_behavior_owner.area_index):
					if !_overlap_area:
						_projectile_updater.get_overlapping_areas(_behavior_owner.area_index).erase(_overlap_area)
						return true
					# print("ProjectileEngine ProjectileEngine: ", ProjectileEngine)
					
					var _overlap_area_collision_layer : int = ProjectileEngine.get_collider_collision_layer(_overlap_area)
					
					if not _overlap_area_collision_layer & _projectile_updater.projectile_collision_mask:
						continue

					if wait_projectile_piercing:
						var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
						if _variable_array.size() <= 0:
							_behavior_variable_piercing = null
							return false
						for _variable in _variable_array:
							if _variable is BehaviorVariablePiercing:
								_behavior_variable_piercing = _variable
								break
							_behavior_variable_piercing = null
						if !_behavior_variable_piercing:
							return false
						if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
							return true
						return false

					# if wait_projectile_bouncing:
					# 	var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
					# 	if _variable_array.size() <= 0:
					# 		_behavior_variable_bouncing = null
					# 		return false
					# 	for _variable in _variable_array:
					# 		if _variable is BehaviorVariableBouncingReflect:
					# 			_behavior_variable_bouncing = _variable
					# 			break
					# 		_behavior_variable_bouncing = null
					# 	if !_behavior_variable_bouncing:
					# 		return false
					# 	if _behavior_variable_bouncing.is_bouncing == false and _behavior_variable_bouncing.is_bouncing_done:
					# 		return true
					# 	return false
					return true

		if destroy_on_body_collide:
			if _projectile_updater.has_overlapping_bodies(_behavior_owner.area_index):
				for _overlap_body in _projectile_updater.get_overlapping_bodies(_behavior_owner.area_index):
					var _overlap_body_collision_layer : int = ProjectileEngine.get_collider_collision_layer(_overlap_body)
					if not _overlap_body_collision_layer & _projectile_updater.projectile_collision_mask:
						continue

					if wait_projectile_piercing:
						var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
						if _variable_array.size() <= 0:
							_behavior_variable_piercing = null
							return false
						for _variable in _variable_array:
							if _variable is BehaviorVariablePiercing:
								_behavior_variable_piercing = _variable
								break
							_behavior_variable_piercing = null
						if !_behavior_variable_piercing:
							return false
						if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
							return true
						return false

					if wait_projectile_bouncing:
						var _variable_array := _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)
						if _variable_array.size() <= 0:
							_behavior_variable_bouncing = null
							return false
						for _variable in _variable_array:
							if _variable is BehaviorVariableBouncingReflect:
								_behavior_variable_bouncing = _variable
								break
							_behavior_variable_bouncing = null
						if !_behavior_variable_bouncing:
							return false
						if _behavior_variable_bouncing.is_bouncing == false and _behavior_variable_bouncing.is_bouncing_done:
							return true
						return false

					return true

	return false
