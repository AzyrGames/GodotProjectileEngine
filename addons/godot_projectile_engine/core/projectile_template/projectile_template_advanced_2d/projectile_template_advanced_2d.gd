extends ProjectileTemplate2D
class_name ProjectileTemplateAdvanced2D

## Template for Advanced Projectile 2D for more Projectile Behavior options
@export_group("Velocity")
@export_subgroup("Speed")
## Movement speed of the projectile - pixels per second
@export var speed: float = 50:
	set(value):
		speed = value
		emit_changed()
## Speed Acceleration to the Max Speed - pixels per second per second
@export var speed_acceleration: float = 0:
	set(value):
		speed_acceleration = value
		emit_changed()
## Maximum speed the projectile can reach -  pixels per second
@export var speed_max: float = 100.0:
	set(value):
		speed_max = value
		emit_changed()
@export_subgroup("Direction")
@export_range(-360, 360, 0.1, "radians_as_degrees", "suffix:°")  var direction_rotation: float:
	set(value):
		direction_rotation = value
		emit_changed()
@export_custom(PROPERTY_HINT_NONE, "suffix:°") var direction_rotation_speed: float = 0.0:
	set(value):
		direction_rotation_speed = value
		emit_changed()
## If true, direction will rotate to match projectile's texture rotation
@export var direction_follow_rotation: bool = false:
	set(value):
		direction_follow_rotation = value
		emit_changed()
@export_group("Texture - Transform")
## The Projectile Instance Texture
@export var texture: Texture2D:
	set(value):
		texture = value
		emit_changed()

@export_subgroup("Rotation")
## Initial rotation of the texture in degrees
@export_range(-360, 360, 0.1, "radians_as_degrees", "suffix:°") var texture_rotation: float:
	set(value):
		texture_rotation = value
		emit_changed()
@export_custom(PROPERTY_HINT_NONE, "suffix:°") var texture_rotation_speed: float = 0.0
## If true, texture rotation will rotate to match projectile's direction
@export var rotation_follow_direction: bool = false

@export_subgroup("Scale")
## The Projectile Instance Scale, default scale: [code](1.0, 1.0)[/code]
@export_custom(PROPERTY_HINT_LINK, "suffix:") var texture_scale: Vector2 = Vector2.ONE:
	set(value):
		texture_scale = value
		emit_changed()
## Acceleration rate in units per second squared (how quickly speed increases)
@export var scale_acceleration: float = 0.0
## Maximum speed the projectile can reach (in units per second)
@export var scale_max: Vector2 = Vector2.ONE * 2

@export_subgroup("Skew")
## Skew/shear effect applied to texture (-89.9 to 89.9 degrees)
@export_range(-89.9, 89.9, 0.1) var texture_skew: float = 0.0:
	set(value):
		texture_skew = value
		emit_changed()
@export_subgroup("Visibility - Ordering")
## Toggles visibility of the projectile's texture
@export var texture_visible: bool = true:
	set(value):
		texture_visible = value
		emit_changed()
## Render layer for the texture (higher values render on top)
@export var texture_z_index: int = 0:
	set(value):
		texture_z_index = value
		emit_changed()
## Reverse Z in dex, make new bullet render underneath older bullet
@export var reverse_z_index: bool = false:
	set(value):
		reverse_z_index = value
		emit_changed()

## Color modulation applied to the texture (RGBA)
@export var texture_modulate: Color = Color(1, 1, 1, 1):
	set(value):
		texture_modulate = value
		emit_changed()

@export_group("Destroy - Collision")
## Collision shape used for physics detection
@export var collision_shape: Shape2D
## Physics layers this projectile can collide with (bitmask)
@export_flags_2d_physics var collision_layer: int = 0
## Physics layers that can detect collisions with this projectile (bitmask)
@export_flags_2d_physics var collision_mask: int = 0
@export var texture_rotate_direction: bool = false:
	set(value):
		texture_rotate_direction = value
		emit_changed()

## Destroy when collided with a body
@export var destroy_on_body_collide: bool = true
## Destroy when collided with a area
@export var destroy_on_area_collide: bool = true

## Maximum lifetime of projectile in seconds before it's automatically destroyed
## [code] life_time_max < 0 [/code] for unlimited life time
@export var life_time_second_max: float = 10.0:
	set(value):
		life_time_second_max = value
		emit_changed()
## Maximum travel distance in pixels before projectile is automatically destroyed [br]
## [code] life_distance_max < 0 [/code] for unlimited distance
@export var life_distance_max: float = 1000.0:
	set(value):
		life_distance_max = value
		emit_changed()

@export_group("Special")
@export_subgroup("Homing")
## Group name to target
@export var is_use_homing: bool = false
@export var target_group: String = ""

## Speed at which the projectile steers toward target (radians per second)
@export_range(-360, 360, 0.1, "radians_as_degrees", "suffix:°") var steer_speed: float = deg_to_rad(10)

## Strength of homing effect (0.0 to 1.0)
@export_range(0.0, 1.0, 0.01) var homing_strength: float = 1.0

## Maximum distance at which homing is active (0 = unlimited)
@export var max_homing_distance: float = 0.0

@export_subgroup("Trigger")
@export var is_use_trigger: bool = false
@export var trigger_name: StringName
@export var trigger_amount: int
@export var trigger_life_time: float = 10.0
@export var trigger_life_distance: float = 1000.0
# @export var trigger_when_destroy : bool
# @export var trigger_when_collide : bool

@export_group("Random")
@export var speed_random: Vector3
@export var speed_acceleration_random: Vector3
@export var speed_max_random: Vector3
@export var texture_rotation_random: Vector3
@export var texture_rotation_speed_random: Vector3
@export var direction_rotation_random: Vector3
@export var direction_rotation_speed_random: Vector3
@export var scale_random: Vector3
@export var scale_max_random: Vector3
@export var scale_acceleration_random: Vector3
# @export var life_time_second_random: Vector3
# @export var life_distance_random: Vector3


## Internal RID (Rendering ID) for the projectile's collision area
var projectile_area_rid: RID
