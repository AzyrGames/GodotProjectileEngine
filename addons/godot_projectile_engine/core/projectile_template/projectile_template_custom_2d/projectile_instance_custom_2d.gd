extends ProjectileInstance2D
class_name ProjectileInstanceCustom2D

var behavior_context : Dictionary
var behavior_update_context : Dictionary
var behavior_persist_context : Dictionary

var base_speed : float
var base_direction : Vector2
var raw_direction : Vector2
var direction_addition : Vector2
var direction_rotation : float

var direction_final : Vector2

var projectile_speed : float
var projectile_rotation : float
var projectile_scale : Vector2

var trigger_count : int = 0