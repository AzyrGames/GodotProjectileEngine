extends ProjectileBehavior
class_name ProjectileBehaviorBouncing


func process_behavior(_value, _context: Dictionary) -> bool:
	return false


#region AI suggestion. Do not touch
# ## Bouncing behavior types
# enum BounceType {
# 	PERFECT_REFLECTION,    ## Perfect elastic collision with no energy loss
# 	DAMPENED_REFLECTION,   ## Reflection with energy loss over time
# 	RANDOM_REFLECTION,     ## Random reflection within a cone
# 	SURFACE_ABSORPTION,    ## Partial absorption by surface material
# 	VELOCITY_DEPENDENT     ## Bounce behavior depends on impact velocity
# }

# ## Surface material types that affect bouncing
# enum SurfaceMaterial {
# 	METAL,      ## High reflection, minimal energy loss
# 	RUBBER,     ## High bounce with some energy retention
# 	WOOD,       ## Medium bounce with moderate energy loss
# 	CONCRETE,   ## Low bounce with significant energy loss
# 	WATER,      ## Very low bounce, high absorption
# 	CUSTOM      ## Use custom values
# }

# ## The type of bouncing behavior to apply
# @export var bounce_type: BounceType = BounceType.DAMPENED_REFLECTION

# ## Surface material that affects bounce characteristics
# @export var surface_material: SurfaceMaterial = SurfaceMaterial.METAL

# ## Energy retention factor (0.0 = no energy, 1.0 = perfect bounce)
# @export_range(0.0, 1.0) var energy_retention: float = 0.8

# ## Random reflection cone angle in degrees (for RANDOM_REFLECTION type)
# @export_range(0.0, 180.0) var reflection_cone_angle: float = 30.0

# ## Minimum velocity threshold for bouncing
# @export var min_bounce_velocity: float = 10.0

# ## Maximum velocity threshold for bouncing behavior
# @export var max_bounce_velocity: float = 1000.0

# ## Speed multiplier applied on bounce
# @export_range(0.0, 2.0) var speed_multiplier: float = 1.0

# ## Enable velocity-dependent energy loss
# @export var velocity_dependent_loss: bool = false

# ## Velocity loss factor (higher values = more loss at high speeds)
# @export_range(0.0, 1.0) var velocity_loss_factor: float = 0.1

# ## Enable surface angle dependency
# @export var angle_dependent_bounce: bool = false

# ## Minimum surface angle for bouncing (in degrees, 0 = perpendicular)
# @export_range(0.0, 90.0) var min_surface_angle: float = 15.0

# ## Enable spin/rotation effects on bounce
# @export var enable_spin_effects: bool = false

# ## Spin factor applied to direction change
# @export_range(-2.0, 2.0) var spin_factor: float = 0.0

# ## Enable bounce count dependency
# @export var bounce_count_dependency: bool = false

# ## Energy loss per bounce (cumulative)
# @export_range(0.0, 1.0) var energy_loss_per_bounce: float = 0.1

# ## Random seed for consistent random behavior
# @export var use_random_seed: bool = false
# @export var random_seed: int = 0

# # Internal variables
# var _rng: RandomNumberGenerator

# func _init() -> void:
# 	_rng = RandomNumberGenerator.new()
# 	if use_random_seed:
# 		_rng.seed = random_seed

# ## Requests context data needed for bouncing calculations
# func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.DIRECTION,
# 		ProjectileEngine.BehaviorContext.BASE_DIRECTION,
# 		ProjectileEngine.BehaviorContext.PHYSICS_DELTA
# 	]

# func _request_persist_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
# 	return [
# 		ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR
# 	]

# ## Processes the bouncing behavior and returns modified direction and speed
# func process_behavior(_value: Vector2, _context: Dictionary) -> Array:
# 	var current_direction = _value as Vector2
# 	var current_speed = _context.get("speed", 100.0) as float
# 	var bounce_count = _context.get("bounce_count", 0) as int
# 	var collision_normal = _context.get("collision_normal", Vector2.UP) as Vector2
# 	var collision_velocity = _context.get("collision_velocity", current_speed) as float
	
# 	# Get or create random number generator
# 	var rng_array = _context.get(ProjectileEngine.BehaviorContext.RANDOM_NUMBER_GENERATOR, [])
# 	if rng_array.size() > 0:
# 		_rng = rng_array[0]
	
# 	# Calculate base reflection
# 	var reflected_direction = current_direction.reflect(collision_normal)
# 	var new_speed = current_speed
	
# 	# Apply bounce type specific modifications
# 	match bounce_type:
# 		BounceType.PERFECT_REFLECTION:
# 			new_speed = current_speed
		
# 		BounceType.DAMPENED_REFLECTION:
# 			new_speed = _apply_dampened_reflection(current_speed, collision_velocity)
		
# 		BounceType.RANDOM_REFLECTION:
# 			reflected_direction = _apply_random_reflection(reflected_direction, collision_normal)
# 			new_speed = _apply_dampened_reflection(current_speed, collision_velocity)
		
# 		BounceType.SURFACE_ABSORPTION:
# 			new_speed = _apply_surface_absorption(current_speed, collision_velocity)
		
# 		BounceType.VELOCITY_DEPENDENT:
# 			new_speed = _apply_velocity_dependent_bounce(current_speed, collision_velocity)
	
# 	# Apply surface material effects
# 	new_speed = _apply_surface_material_effects(new_speed, collision_velocity)
	
# 	# Apply angle dependency
# 	if angle_dependent_bounce:
# 		var surface_angle = rad_to_deg(acos(abs(current_direction.dot(collision_normal))))
# 		if surface_angle < min_surface_angle:
# 			# Shallow angle, reduce bounce effectiveness
# 			new_speed *= (surface_angle / min_surface_angle)
	
# 	# Apply spin effects
# 	if enable_spin_effects and spin_factor != 0.0:
# 		var spin_rotation = deg_to_rad(spin_factor * new_speed * 0.01)
# 		reflected_direction = reflected_direction.rotated(spin_rotation)
	
# 	# Apply bounce count dependency
# 	if bounce_count_dependency and bounce_count > 0:
# 		var cumulative_loss = 1.0 - (energy_loss_per_bounce * bounce_count)
# 		new_speed *= max(0.1, cumulative_loss)
	
# 	# Apply velocity thresholds
# 	if new_speed < min_bounce_velocity:
# 		new_speed = 0.0  # Stop bouncing
# 	elif new_speed > max_bounce_velocity:
# 		new_speed = max_bounce_velocity
	
# 	# Apply speed multiplier
# 	new_speed *= speed_multiplier
	
# 	return [reflected_direction.normalized(), new_speed]

# ## Applies dampened reflection with energy loss
# func _apply_dampened_reflection(current_speed: float, collision_velocity: float) -> float:
# 	var base_retention = _get_material_energy_retention()
	
# 	if velocity_dependent_loss:
# 		# Higher speeds lose more energy
# 		var velocity_factor = 1.0 - (collision_velocity / max_bounce_velocity) * velocity_loss_factor
# 		base_retention *= max(0.1, velocity_factor)
	
# 	return current_speed * base_retention

# ## Applies random reflection within a cone
# func _apply_random_reflection(reflected_direction: Vector2, collision_normal: Vector2) -> Vector2:
# 	var cone_angle_rad = deg_to_rad(reflection_cone_angle)
# 	var random_angle = _rng.randf_range(-cone_angle_rad * 0.5, cone_angle_rad * 0.5)
	
# 	# Create a random direction within the reflection cone
# 	var base_angle = reflected_direction.angle()
# 	var new_angle = base_angle + random_angle
	
# 	return Vector2.from_angle(new_angle)

# ## Applies surface absorption based on material
# func _apply_surface_absorption(current_speed: float, collision_velocity: float) -> float:
# 	var absorption_factor = _get_material_absorption_factor()
# 	var absorbed_energy = collision_velocity * absorption_factor
	
# 	return max(0.0, current_speed - absorbed_energy)

# ## Applies velocity-dependent bouncing
# func _apply_velocity_dependent_bounce(current_speed: float, collision_velocity: float) -> float:
# 	# Low velocity = high retention, high velocity = low retention
# 	var velocity_ratio = collision_velocity / max_bounce_velocity
# 	var dynamic_retention = 1.0 - (velocity_ratio * 0.5)  # Max 50% loss at max velocity
	
# 	return current_speed * max(0.1, dynamic_retention) * energy_retention

# ## Applies surface material effects to speed
# func _apply_surface_material_effects(speed: float, collision_velocity: float) -> float:
# 	var material_retention = _get_material_energy_retention()
# 	return speed * material_retention

# ## Gets energy retention factor based on surface material
# func _get_material_energy_retention() -> float:
# 	match surface_material:
# 		SurfaceMaterial.METAL:
# 			return 0.95
# 		SurfaceMaterial.RUBBER:
# 			return 0.85
# 		SurfaceMaterial.WOOD:
# 			return 0.65
# 		SurfaceMaterial.CONCRETE:
# 			return 0.45
# 		SurfaceMaterial.WATER:
# 			return 0.25
# 		SurfaceMaterial.CUSTOM:
# 			return energy_retention
# 		_:
# 			return energy_retention

# ## Gets absorption factor based on surface material
# func _get_material_absorption_factor() -> float:
# 	match surface_material:
# 		SurfaceMaterial.METAL:
# 			return 0.05
# 		SurfaceMaterial.RUBBER:
# 			return 0.15
# 		SurfaceMaterial.WOOD:
# 			return 0.35
# 		SurfaceMaterial.CONCRETE:
# 			return 0.55
# 		SurfaceMaterial.WATER:
# 			return 0.75
# 		SurfaceMaterial.CUSTOM:
# 			return 1.0 - energy_retention
# 		_:
# 			return 1.0 - energy_retention

# ## Sets custom energy retention (for CUSTOM material)
# func set_custom_energy_retention(retention: float) -> void:
# 	energy_retention = clamp(retention, 0.0, 1.0)
# 	surface_material = SurfaceMaterial.CUSTOM

# ## Sets random reflection parameters
# func set_random_reflection(cone_angle: float, seed: int = -1) -> void:
# 	bounce_type = BounceType.RANDOM_REFLECTION
# 	reflection_cone_angle = clamp(cone_angle, 0.0, 180.0)
	
# 	if seed >= 0:
# 		use_random_seed = true
# 		random_seed = seed
# 		_rng.seed = seed

# ## Enables velocity-dependent behavior with custom parameters
# func enable_velocity_dependency(loss_factor: float = 0.1, min_vel: float = 10.0, max_vel: float = 1000.0) -> void:
# 	velocity_dependent_loss = true
# 	velocity_loss_factor = clamp(loss_factor, 0.0, 1.0)
# 	min_bounce_velocity = min_vel
# 	max_bounce_velocity = max_vel

# ## Enables surface angle dependency
# func enable_angle_dependency(min_angle: float = 15.0) -> void:
# 	angle_dependent_bounce = true
# 	min_surface_angle = clamp(min_angle, 0.0, 90.0)

# ## Enables spin effects on bouncing
# func set_spin_effects(spin: float = 0.5) -> void:
# 	enable_spin_effects = true
# 	spin_factor = clamp(spin, -2.0, 2.0)

# ## Creates a preset bouncing behavior
# static func create_preset(preset_name: String) -> ProjectileBehaviorBouncing:
# 	var behavior = ProjectileBehaviorBouncing.new()
	
# 	match preset_name.to_lower():
# 		"rubber_ball":
# 			behavior.bounce_type = BounceType.DAMPENED_REFLECTION
# 			behavior.surface_material = SurfaceMaterial.RUBBER
# 			behavior.energy_retention = 0.85
# 			behavior.speed_multiplier = 1.0
		
# 		"metal_ricochet":
# 			behavior.bounce_type = BounceType.PERFECT_REFLECTION
# 			behavior.surface_material = SurfaceMaterial.METAL
# 			behavior.energy_retention = 0.95
# 			behavior.enable_spin_effects = true
# 			behavior.spin_factor = 0.3
		
# 		"chaotic_bounce":
# 			behavior.bounce_type = BounceType.RANDOM_REFLECTION
# 			behavior.surface_material = SurfaceMaterial.CONCRETE
# 			behavior.reflection_cone_angle = 45.0
# 			behavior.energy_retention = 0.6
		
# 		"water_splash":
# 			behavior.bounce_type = BounceType.SURFACE_ABSORPTION
# 			behavior.surface_material = SurfaceMaterial.WATER
# 			behavior.energy_retention = 0.25
# 			behavior.velocity_dependent_loss = true
		
# 		"high_energy":
# 			behavior.bounce_type = BounceType.VELOCITY_DEPENDENT
# 			behavior.surface_material = SurfaceMaterial.METAL
# 			behavior.velocity_dependent_loss = true
# 			behavior.velocity_loss_factor = 0.05
# 			behavior.speed_multiplier = 1.1
		
# 		_:
# 			# Default behavior
# 			behavior.bounce_type = BounceType.DAMPENED_REFLECTION
# 			behavior.surface_material = SurfaceMaterial.METAL
# 			behavior.energy_retention = 0.8
	
# 	return behavior
#endregion