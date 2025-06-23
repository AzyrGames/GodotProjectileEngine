# extends ProjectileBehaviorBouncing
# class_name ChaoticBounce

# ## Preset bouncing behavior that creates chaotic, unpredictable bouncing
# ## Perfect for magical projectiles or special effects

# func _init() -> void:
# 	super._init()
	
# 	# Configure chaotic bouncing behavior
# 	bounce_type = BounceType.RANDOM_REFLECTION
# 	surface_material = SurfaceMaterial.CONCRETE
# 	energy_retention = 0.6
# 	speed_multiplier = 1.1
	
# 	# Large reflection cone for chaotic behavior
# 	reflection_cone_angle = 60.0
	
# 	# Enable random seed for varied behavior
# 	use_random_seed = false  # Different each time
	
# 	# Enable spin effects for extra chaos
# 	enable_spin_effects = true
# 	spin_factor = 1.0
	
# 	# Velocity dependency adds more unpredictability
# 	velocity_dependent_loss = true
# 	velocity_loss_factor = 0.2
	
# 	# Moderate velocity thresholds
# 	min_bounce_velocity = 30.0
# 	max_bounce_velocity = 1000.0
	
# 	# Significant energy loss per bounce to prevent infinite bouncing
# 	bounce_count_dependency = true
# 	energy_loss_per_bounce = 0.08
