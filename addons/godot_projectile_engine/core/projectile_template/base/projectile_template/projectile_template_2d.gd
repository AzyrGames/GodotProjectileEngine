extends Resource
class_name ProjectileTemplate2D

## Number of projectiles to preload in the object pool for better performance
@export var projectile_pooling_amount: int = 500:
	set(value):
		projectile_pooling_amount = value
		emit_changed()

@export var custom_data : ProjectileCustomData
