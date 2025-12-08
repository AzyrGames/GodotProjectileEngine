extends Object
class_name ProjectileInstance2D

var projectile_template_2d : ProjectileTemplate2D
var projectile_updater_2d: ProjectileUpdater2D

var area_rid: RID
var area_index: int
var canvas_item_rid: RID

var speed: float
var direction: Vector2 = Vector2.RIGHT
var direction_rotation: float = 0

var velocity: Vector2 = Vector2.ZERO

var transform_2d: Transform2D
var global_position: Vector2 = Vector2.ZERO
var texture_rotation: float = 0
var texture_scale: Vector2 = Vector2.ONE
var texture_skew: float = 0.0

var life_time_second: float = 0.0
var life_time_tick: int = 0.0
var life_distance: float = 0.0

var custom_data: ProjectileCustomData