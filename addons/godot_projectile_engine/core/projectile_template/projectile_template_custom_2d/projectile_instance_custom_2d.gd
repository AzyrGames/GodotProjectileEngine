extends ProjectileInstance2D
class_name ProjectileInstanceCustom2D

var behavior_context : Dictionary
var behavior_update_context : Dictionary
var behavior_persist_context : Dictionary

var base_speed : float
var base_direction : Vector2
var base_direction_rotation : float
var base_texture_rotation : float
var base_scale : Vector2
var base_skew : float
var speed_clamp : Vector2

var speed_final : float

var raw_direction : Vector2
var direction_addition : Vector2
var direction_final : Vector2

var direction_rotation_speed: float
var texture_rotation_speed: float

var projectile_speed : float
var projectile_rotation : float
var projectile_scale : Vector2

var trigger_count : int = 0
