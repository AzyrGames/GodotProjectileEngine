extends Node
class_name BulletTemplate2D


@export_group("ID")
@export var template_id : String:
	set(value):
		BulletHell.template_nodes.erase(template_id)
		BulletHell.template_nodes.get_or_add(template_id, self)
		template_id = value
		pass

@export_category("Texture")
@export_group("Texture")

@export var texture : Texture2D
@export var texture_render_priority : int = 0
@export var texture_rotation_speed : float = 0.0

## Rotate texture base on direction. This overwrite Texture Rotation Speed
@export var texture_rotate_direction: bool = false
@export_group("Animation")
@export var use_animation : bool = false
@export var animated_sprite : SpriteFrames
@export var animation_name : String

@export_category("Movement")

@export var move_speed : float = 100
@export var direction_rotation_speed : float = 0.0
@export var life_time_max : float = 5.0

@export_group("Move speed Change")

enum MoveSpeedChangeType{
	MODIFICATION, 
	HARD_VALUE, 
}
enum LoopType {
	ONCE_AND_KEEP, 
	LOOP_FROM_START, 
	PING_PONG,
}
@export var is_move_speed_change : bool = false
@export var move_speed_change_type : MoveSpeedChangeType
@export var move_speed_change_loop : LoopType
@export var move_speed_curve : Curve
@export var is_caching_move_speed_change : bool = true

var move_speed_cache_value : Array[float]
var move_speed_change_max_tick : int


@export_group("Move Direction Change")
enum MoveDirectionChangeType{
	ROTATION, ## The Direction Change will keep related to the original Move Direction
	HARD_DIRECTION, ## Overrite the current Move Direction with curve Direcion
	HARD_POSITION, ## Overrite the current position with curve Position

}

@export var is_move_direction_change : bool = false
@export var move_direction_change_type : MoveDirectionChangeType
@export var move_direction_change_loop : LoopType
@export var move_direction_curve2d : Curve2D 



@export_category("Bullet")
@export var bullet_damage : int = 1
@export var bullet_pooling_amount : int = 500
@export_group("Collision")
@export var collision_shape : Shape2D
@export_flags_2d_physics var collision_layer : int = 0:
	set(value):
		collision_layer = value
		PhysicsServer2D.area_set_collision_layer(bullet_area_rid, collision_layer)

@export_flags_2d_physics var collision_mask : int = 0:
	set(value):
		collision_mask = value
		PhysicsServer2D.area_set_collision_layer(bullet_area_rid, collision_mask)

var bullet_area_rid : RID

func _ready() -> void:
	BulletHell.template_nodes.get_or_add(template_id, self)


func caching_move_speed_change_value() -> void:
	if !is_move_speed_change: return
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	move_speed_change_max_tick = int(move_speed_curve.max_domain / _tick_time)
	for i in range(move_speed_change_max_tick):
		move_speed_cache_value.append(move_speed_curve.sample(_tick_time * i))
	pass
