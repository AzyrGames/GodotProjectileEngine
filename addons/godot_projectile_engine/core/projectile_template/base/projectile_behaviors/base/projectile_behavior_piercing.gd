extends ProjectileBehavior
class_name ProjectileBehaviorPiercing

## Base class for all projectile piercing behaviors in the projectile engine.
##
## Piercing behaviors determine how projectiles interact with targets
## they can pierce through.

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER
	]

func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE
	]

@export var piercing_count : int = 3
@export var pierce_area : bool = false
@export_flags_2d_physics var pierce_area_layer : int = 0
@export var pierce_body : bool = false
@export_flags_2d_physics var pierce_body_layer : int = 0


var _variable_array : Array
var _behavior_variable_piercing : BehaviorVariablePiercing
var _should_piercing : bool = false

var _piercing_behavior_values : Dictionary

## Processes the piercing behavior and returns whether piercing should occur
## Returns bool: true if projectile should pierce, false if it should be stopped/destroyed
func process_behavior(_value, _context: Dictionary) -> Dictionary:
	if piercing_count <= 0:
		return {}

	if !pierce_area and !pierce_body:
		return {}

	if !_context.has(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE):
		return {}

	_variable_array = _context.get(ProjectileEngine.BehaviorContext.ARRAY_VARIABLE)

	if _variable_array.size() <= 0:
		_behavior_variable_piercing = null

	for _variable in _variable_array:
		if _variable is BehaviorVariablePiercing:
			if !_variable.is_processed:
				_behavior_variable_piercing = _variable
				break
		else:
			_behavior_variable_piercing = null

	if _behavior_variable_piercing == null:
		_behavior_variable_piercing = BehaviorVariablePiercing.new()
		_variable_array.append(_behavior_variable_piercing)

	_should_piercing = false
	_piercing_behavior_values = {}
	_behavior_variable_piercing.is_processed = true

	if _behavior_variable_piercing.is_overlap_piercing == false and _behavior_variable_piercing.is_piercing_done:
		return {}

	if _behavior_variable_piercing.is_piercing_just_done:
		_behavior_variable_piercing.is_piercing_done = true

	if not _context.has(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER):
		return {}

	var _behavior_owner = _context.get(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER)
	if not _behavior_owner:
		return {}

	if _behavior_owner is Projectile2D:
		if pierce_area:
			if _behavior_owner.has_overlapping_areas():
				var _overlap_areas : Array[Area2D] = _behavior_owner.get_overlapping_areas()
				for _overlap_area in _overlap_areas:
					if _behavior_variable_piercing.pierced_targets.has(_overlap_area):
						continue
					if not _overlap_area.collision_layer & pierce_area_layer:
						continue

					_should_piercing = true
					_piercing_behavior_values["is_piercing"] = true
					_piercing_behavior_values["pierced_node"] = _overlap_area
					_behavior_variable_piercing.is_overlap_piercing = true
					_behavior_variable_piercing.pierced_targets.append(_overlap_area)

					if piercing_count == 1:
						_behavior_variable_piercing.is_piercing_just_done = true
					elif _behavior_variable_piercing.current_piercing_count < piercing_count - 1:
						_behavior_variable_piercing.current_piercing_count += 1
					else:
						_behavior_variable_piercing.is_piercing_just_done = true
			else:
				_behavior_variable_piercing.is_overlap_piercing = false
		if pierce_body:
			if _behavior_owner.has_overlapping_bodies():
				var _overlap_bobies : Array[Area2D] = _behavior_owner.get_overlapping_bodies()
				for _overlap_body in _overlap_bobies:
					if _behavior_variable_piercing.pierced_targets.has(_overlap_body):
						continue
					if not _overlap_body.collision_layer & pierce_area_layer:
						continue

					_should_piercing = true
					_piercing_behavior_values["is_piercing"] = true
					_piercing_behavior_values["pierced_node"] = _overlap_body
					_behavior_variable_piercing.is_overlap_piercing = true
					_behavior_variable_piercing.pierced_targets.append(_overlap_body)

					if piercing_count == 1:
						_behavior_variable_piercing.is_piercing_just_done = true
					elif _behavior_variable_piercing.current_piercing_count < piercing_count - 1:
						_behavior_variable_piercing.current_piercing_count += 1
					else:
						_behavior_variable_piercing.is_piercing_just_done = true
			else:
				_behavior_variable_piercing.is_overlap_piercing = false

	elif _behavior_owner is ProjectileInstance2D:
		var _projectile_updater : ProjectileUpdater2D = _behavior_owner.projectile_updater
		if pierce_area:
			if _projectile_updater.has_overlapping_areas(_behavior_owner.area_index):
				for _overlap_area in _projectile_updater.get_overlapping_areas(_behavior_owner.area_index):
					if not _overlap_area.collision_layer & _projectile_updater.projectile_collision_mask:
						continue
					if _behavior_variable_piercing.pierced_targets.has(_overlap_area):
						continue
					if not _overlap_area.collision_layer & pierce_area_layer:
						continue

					_should_piercing = true
					_piercing_behavior_values["is_piercing"] = true
					_piercing_behavior_values["pierced_node"] = _overlap_area
					_behavior_variable_piercing.is_overlap_piercing = true
					_behavior_variable_piercing.pierced_targets.append(_overlap_area)

					if piercing_count == 1:
						_behavior_variable_piercing.is_piercing_just_done = true
					elif _behavior_variable_piercing.current_piercing_count < piercing_count - 1:
						_behavior_variable_piercing.current_piercing_count += 1
					else:
						_behavior_variable_piercing.is_piercing_just_done = true
			else:
				_behavior_variable_piercing.is_overlap_piercing = false

		if pierce_body:
			if _projectile_updater.has_overlapping_bodies(_behavior_owner.area_index):
				for _overlap_body in _projectile_updater.get_overlapping_bodies(_behavior_owner.area_index):
					if not _overlap_body.collision_layer & _projectile_updater.projectile_collision_mask:
						continue
					if _behavior_variable_piercing.pierced_targets.has(_overlap_body):
						continue
					if not _overlap_body.collision_layer & pierce_area_layer:
						continue

					_should_piercing = true
					_piercing_behavior_values["is_piercing"] = true
					_piercing_behavior_values["pierced_node"] = _overlap_body
					_behavior_variable_piercing.is_overlap_piercing = true
					_behavior_variable_piercing.pierced_targets.append(_overlap_body)

					if piercing_count == 1:
						_behavior_variable_piercing.is_piercing_just_done = true
					elif _behavior_variable_piercing.current_piercing_count < piercing_count - 1:
						_behavior_variable_piercing.current_piercing_count += 1
					else:
						_behavior_variable_piercing.is_piercing_just_done = true
			else:
				_behavior_variable_piercing.is_overlap_piercing = false

	return _piercing_behavior_values
