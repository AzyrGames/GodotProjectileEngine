extends ProjectileTemplate2D
class_name ProjectileTemplateAdvanced2D

## Template for Advanced Projectile 2D for more Projectile Behavior options

## Base damage dealt by the projectile
@export var damage: float = 1.0
## Movement speed of the projectile in pixels per second
@export var speed : float = 100
@export var projectile_pooling_amount : int = 500
@export var life_time_max : float = 10.0
## Maximum travel distance in pixels before projectile is automatically destroyed [br]
## [code] life_distance_max < 0 [/code] for unlimited distance
@export var life_distance_max : float = 1000.0


@export_group("Movement")
@export_subgroup("Speed")

@export var speed_acceleration : float 
## Maximum speed the projectile can reach (in units per second)
@export var speed_max : float = 200.0
## Maximum lifetime of projectile in seconds before it's automatically destroyed
## [code] life_time_max < 0 [/code] for unlimited life time

## Number of projectiles to preload in the object pool for better performance
@export_subgroup("Homing")
## Group name to target
@export var is_use_homing : bool = false
@export var target_group: String = ""

## Speed at which the projectile steers toward target (radians per second)
@export_range(-180, 180, 0.1, "radians_as_degrees") var steer_speed: float = deg_to_rad(10)

## Strength of homing effect (0.0 to 1.0)
@export_range(0.0, 1.0, 0.01) var homing_strength: float = 1.0

## Maximum distance at which homing is active (0 = unlimited)
@export var max_homing_distance: float = 0.0

@export_group("Texture")
## Texture to use for the projectile
@export var texture : Texture2D
## Toggles visibility of the projectile's texture
@export var texture_visible : bool = true
## Render layer for the texture (higher values render on top)
@export var texture_z_index : int = 0
## Color modulation applied to the texture (RGBA)
@export var texture_modulate : Color = Color(1, 1, 1, 1)
## Skew/shear effect applied to texture (-89.9 to 89.9 degrees)
@export_range(-89.9, 89.9, 0.1) var texture_skew : float = 0.0
@export_subgroup("Rotation")
## Initial rotation of the texture in degrees
@export_range(-360.0, 360.0) var texture_rotation : float
## If true, texture rotation will rotate to match projectile's direction
@export var rotation_follow_direction: bool = false
## If true, direction will rotate to match projectile's texture rotation
@export var direction_follow_rotation: bool = false

## Scale multiplier for the projectile texture
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_speed : float = 0.0

@export_subgroup("Scale")

@export_custom(PROPERTY_HINT_LINK, "suffix:") var texture_scale : Vector2 = Vector2.ONE
## Acceleration rate in units per second squared (how quickly speed increases)
@export var scale_acceleration: float = 0.0
## Maximum speed the projectile can reach (in units per second)
@export var scale_max : float = 2.0

@export_group("Collision")
## Collision shape used for physics detection
@export var collision_shape : Shape2D
## Physics layers this projectile can collide with (bitmask)
@export_flags_2d_physics var collision_layer : int = 0
## Physics layers that can detect collisions with this projectile (bitmask)
@export_flags_2d_physics var collision_mask : int = 0

@export_group("Trigger")
@export var is_use_trigger : bool = false
@export var trigger_name : StringName
@export var trigger_amount : int
@export var trigger_life_time : float = 10.0
@export var trigger_life_distance : float = 1000.0
# @export var trigger_when_destroy : bool
# @export var trigger_when_collide : bool




## Internal RID (Rendering ID) for the projectile's collision area
var projectile_area_rid : RID
