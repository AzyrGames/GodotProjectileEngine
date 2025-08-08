extends Object
class_name ProjectileInstance2D

var projectile_updater: ProjectileUpdater2D

var area_rid: RID
var area_index: int

var speed: float
var direction: Vector2 = Vector2.RIGHT
var direction_rotation: float = 0

var velocity: Vector2 = Vector2.ZERO

var global_position: Vector2 = Vector2.ZERO
var texture_rotation: float = 0
var scale: Vector2 = Vector2.ONE
var skew: float = 0.0
var transform: Transform2D

var life_time_second: float = 0.0
var life_time_tick: float = 0.0
var life_distance: float = 0.0

var life_time_second_max: float = 0.0
var life_time_tick_max: float = 0.0
var life_distance_max: float = 0.0

var custom_data: Array[Variant]