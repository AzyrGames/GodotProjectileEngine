# extends ProjectileBehaviorDirection
# class_name ProjectileDirectionHomingAdvanced

## @deprecated

# ## Target-based homing behavior that steers projectiles toward specific targets

# enum TargetType {
# 	GROUP,
# 	NODE,
# 	POSITION
# }


# ## Type of target to home towards
# @export var target_type: TargetType = TargetType.GROUP

# ## Group name to target (when target_type is GROUP)
# @export var target_group: String = ""

# ## Specific node path to target (when target_type is NODE)
# @export var target_node_path: NodePath

# ## Fixed position to target (when target_type is POSITION)
# @export var target_position: Vector2

# ## How to select target from group
# @export var group_selection: ProjectileEngine.TargetGroupSelection = ProjectileEngine.TargetGroupSelection.NEAREST

# ## Speed at which the projectile steers toward target (radians per second)
# @export var steer_speed: float = 5.0

# ## How the homing modifies the direction
# @export var direction_modify_method: DirectionModifyMethod = DirectionModifyMethod.OVERRIDE

# ## Maximum distance at which homing is active (0 = unlimited)
# @export var max_homing_distance: float = 0.0

# ## Minimum distance at which homing stops (prevents orbiting)
# @export var min_homing_distance: float = 10.0

# ## Strength of homing effect (0.0 to 1.0)
# @export var homing_strength: float = 1.0

# var current_target: Node2D
# var current_target_position: Vector2


# ## Returns required context values for this behavior
# func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.PHYSICS_DELTA,
# 		ProjectileEngine.BehaviorContext.GLOBAL_POSITION,
# 		ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER,

# 	]

# func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.ARRAY_VARIABLE
# 	]


# ## Processes homing behavior by steering toward target
# func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
# 	if not _context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
# 		return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: _value}
	

# 	var delta: float = _context[ProjectileEngine.BehaviorContext.PHYSICS_DELTA]
# 	if not _context.has(ProjectileEngine.BehaviorContext.GLOBAL_POSITION):
# 		return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: _value}


# 	var projectile_position: Vector2 = _context.get(ProjectileEngine.BehaviorContext.GLOBAL_POSITION)
	
# 	# Find target
# 	var target_pos: Variant = _find_target(projectile_position, _context)
# 	if target_pos == null:
# 		return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: _value}
	
# 	# Calculate distance to target
# 	var distance_to_target: float = projectile_position.distance_to(target_pos)
	
# 	# Check distance constraints
# 	if max_homing_distance > 0.0 and distance_to_target > max_homing_distance:
# 		return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: _value}
	
# 	if distance_to_target < min_homing_distance:
# 		return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: _value}
	
# 	# Calculate desired direction toward target
# 	var desired_direction: Vector2 = projectile_position.direction_to(target_pos)
	
# 	# Apply homing based on modify method
# 	match direction_modify_method:
# 		DirectionModifyMethod.OVERRIDE:
# 			# Gradually steer toward target
# 			var new_direction: Vector2 = _value.move_toward(desired_direction, steer_speed * delta)
# 			return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: new_direction.normalized() * homing_strength + _value * (1.0 - homing_strength)}

# 		DirectionModifyMethod.ADDITION:
# 			# Add homing force as direction addition
# 			var homing_force: Vector2 = desired_direction * homing_strength * steer_speed * delta
# 			return {ProjectileEngine.DirectionModify.DIRECTION_ADDITION : homing_force}
# 		null:
# 			return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: _value}
# 		_:
# 			return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: _value}

# 	return {ProjectileEngine.DirectionModify.DIRECTION_OVERWRITE: _value}

# ## Finds the target position based on target type
# func _find_target(projectile_position: Vector2, _context: Dictionary) -> Variant:
# 	match target_type:
# 		TargetType.POSITION:
# 			return target_position
			
# 		TargetType.NODE:
# 			if target_node_path.is_empty():
# 				return null
# 			if !_context.has(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER):
# 				return null
# 			var behavior_owner : Node = _context.get(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER)
# 			if !behavior_owner:
# 				return null
# 			var target_node = behavior_owner.get_node_or_null(target_node_path)
# 			if target_node and target_node is Node2D and is_instance_valid(target_node):
# 				return target_node.global_position
# 			return null

# 		TargetType.GROUP:
# 			if target_group.is_empty():
# 				return null
			
# 			# Filter to Node2D objects
# 			var _valid_nodes: Array[Node2D] = ProjectileEngine.get_valid_target_group_nodes(target_group)

# 			if _valid_nodes.is_empty():
# 				return null
			
# 			# Select target based on group selection method
# 			match group_selection:
# 				ProjectileEngine.TargetGroupSelection.FIRST:
# 					return _valid_nodes[0].global_position
					
# 				ProjectileEngine.TargetGroupSelection.NEAREST:
# 					var nearest_target: Node2D = _valid_nodes[0]
# 					var nearest_distance: float = projectile_position.distance_to(nearest_target.global_position)
					
# 					for target in _valid_nodes:
# 						var distance: float = projectile_position.distance_to(target.global_position)
# 						if distance < nearest_distance:
# 							nearest_distance = distance
# 							nearest_target = target
					
# 					return nearest_target.global_position
					
# 				ProjectileEngine.TargetGroupSelection.RANDOM:
# 					var random_target: Node2D = _valid_nodes[randi() % _valid_nodes.size()]
# 					return random_target.global_position
	
# 	return null
