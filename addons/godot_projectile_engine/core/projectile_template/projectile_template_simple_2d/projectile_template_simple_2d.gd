extends ProjectileTemplate2D
class_name ProjectileTemplateSimple2D

@export var damage: float = 1.0
@export var speed : float = 100
@export var life_time_max : float = 10.0
@export var life_distance_max : float = 300.0
@export var projectile_pooling_amount : int = 500

@export var texture : Texture2D
@export_range(-360.0, 360.0) var texture_rotation : float
@export var texture_rotate_direction: bool = false
@export var texture_scale : Vector2 = Vector2.ONE
@export_range(-89.9, 89.9, 0.1) var texture_skew : float = 0.0

@export var texture_visible : bool = true
@export var texture_z_index : int = 0
@export var texture_modulate : Color = Color(1, 1, 1, 1)

@export var collision_shape : Shape2D
@export_flags_2d_physics var collision_layer : int = 0
@export_flags_2d_physics var collision_mask : int = 0

var projectile_area_rid : RID