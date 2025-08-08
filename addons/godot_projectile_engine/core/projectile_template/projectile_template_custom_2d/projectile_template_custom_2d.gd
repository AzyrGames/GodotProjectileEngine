extends ProjectileTemplate2D
class_name ProjectileTemplateCustom2D

## Template for Custom Projectile 2D that using ProjectileBehavior

## Base damage dealt by the projectile
@export var damage: float = 1.0
## Movement speed of the projectile in pixels per second
@export var speed : float = 100
# ## The normalized Direction of the projectile moving toward
# @export var direction : Vector2 = Vector2.RIGHT
## Number of projectiles to preload in the object pool for better performance
@export var projectile_pooling_amount : int = 500

@export_group("Texture")
## The Projectile Instance Texture
@export var texture : Texture2D
## The Projectile Instance Scale, default scale: [code](1.0, 1.0)[/code]
@export_custom(PROPERTY_HINT_LINK, "") var scale : Vector2 = Vector2.ONE
## Initial rotation of the texture in degrees
@export_range(-360, 360, 0.1, "radians_as_degrees", "suffix:°") var texture_rotation : float
## Skew/shear effect applied to texture (-89.9 to 89.9 degrees)
@export_range(-89.9, 89.9, 0.1) var skew : float = 0.0
## Toggles visibility of the projectile's texture
@export var texture_visible : bool = true
## Render layer for the texture (higher values render on top)
@export var texture_z_index : int = 0
## Color modulation applied to the texture (RGBA)
@export var texture_modulate : Color = Color(1, 1, 1, 1)

@export_group("Collision")
## Collision shape used for physics detection
@export var collision_shape : Shape2D
## Physics layers this projectile can collide with (bitmask)
@export_flags_2d_physics var collision_layer : int = 0
## Physics layers that can detect collisions with this projectile (bitmask)
@export_flags_2d_physics var collision_mask : int = 0

@export_group("Transform")
@export var speed_projectile_behaviors : Array[ProjectileBehaviorSpeed]
@export var direction_projectile_behaviors : Array[ProjectileBehaviorDirection]
@export var rotation_projectile_behaviors : Array[ProjectileBehaviorRotation]
@export var scale_projectile_behaviors : Array[ProjectileBehaviorScale]

@export_group("Special")
@export var destroy_projectile_behaviors : Array[ProjectileBehaviorDestroy]
@export var piercing_projectile_behaviors : Array[ProjectileBehaviorPiercing]
@export var bouncing_projectile_behaviors : Array[ProjectileBehaviorBouncing]
@export var trigger_projectile_behaviors : Array[ProjectileBehaviorTrigger]

@export_group("Random")
@export var speed_random: Vector3
@export var texture_rotation_random: Vector3
@export var scale_random: Vector3


## Internal RID (Rendering ID) for the projectile's collision area
var projectile_area_rid : RID



