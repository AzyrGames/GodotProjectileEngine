extends ProjectileTemplate2D
class_name ProjectileTemplateSimple2D

## Template for Simple Projectile 2D that will move at the direction and speed defined.

## Movement speed of the projectile in pixels per second
@export var speed: float = 100

## Number of projectiles to preload in the object pool for better performance
@export var projectile_pooling_amount: int = 500

## The Projectile Instance Texture
@export var texture: Texture2D
## The Projectile Instance Scale, default scale: [code](1.0, 1.0)[/code]
@export_custom(PROPERTY_HINT_LINK, "suffix:") var scale: Vector2 = Vector2.ONE

## Initial rotation of the texture in degrees
@export_range(-360, 360, 0.1, "radians_as_degrees", "suffix:°")  var texture_rotation: float
## Skew/shear effect applied to texture (-89.9 to 89.9 degrees)
@export_range(-89.9, 89.9, 0.1) var skew: float = 0.0
## Toggles visibility of the projectile's texture
@export var texture_visible: bool = true
## Render layer for the texture (higher values render on top)
@export var texture_z_index: int = 0
## Color modulation applied to the texture (RGBA)
@export var texture_modulate: Color = Color(1, 1, 1, 1)

## Collision shape used for physics detection
@export var collision_shape: Shape2D
## Physics layers this projectile can collide with (bitmask)
@export_flags_2d_physics var collision_layer: int = 0
## Physics layers that can detect collisions with this projectile (bitmask)
@export_flags_2d_physics var collision_mask: int = 0
@export var texture_rotate_direction: bool = false
## Destroy when collided with a body
@export var destroy_on_body_collide: bool = true
## Destroy when collided with a area
@export var destroy_on_area_collide: bool = true
## Maximum lifetime of projectile in seconds before it's automatically destroyed
## [code] life_time_max < 0 [/code] for unlimited life time
@export var life_time_second_max: float = 10.0
## Maximum travel distance in pixels before projectile is automatically destroyed [br]
## [code] life_distance_max < 0 [/code] for unlimited distance
@export var life_distance_max: float = 1000.0

@export_group("Random")
@export var speed_random: Vector3
@export var texture_rotation_random: Vector3
@export var texture_rotation_speed_random: Vector3
@export var scale_random: Vector3
@export var life_time_second_random : Vector3
@export var life_distance_random : Vector3
# @export var hue_variation : Vector3

## Internal RID (Rendering ID) for the projectile's collision area
var projectile_area_rid: RID
