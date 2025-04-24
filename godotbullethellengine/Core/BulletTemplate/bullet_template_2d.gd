
extends Resource
class_name BulletTemplate2D


@export_group("Bullet")
@export var bullet_damage : int = 1

@export var move_speed : float = 100
@export var direction_rotation_speed : float = 0.0

@export_subgroup("Destroy")


@export var life_time_max : float = 5.0
@export var life_distance_max : float = 300.0
@export var destroy_on_collision : bool = false

@export_subgroup("Pooling")
@export var bullet_pooling_amount : int = 500

@export_group("Texture")

@export var texture : Texture2D
@export var texture_z_index : int = 0
@export var texture_rotate_direction: bool = false

# @export var texture_offset : Vector2 = Vector2.ZERO
@export_range(-360.0, 360.0) var texture_rotation : float
@export var texture_scale : Vector2 = Vector2.ONE
# @export_range(-89.9, 89.9) var texture_skew : float

@export_subgroup("Texture Advanced")
enum TextureScaleChangeType{
	MULTIPLIER, 
	HARD_VALUE, 
}
@export var texture_rotation_speed : float = 0.0

@export var is_texture_scale_change : bool = false
@export var texture_scale_curve : Curve
@export var texture_scale_type : TextureScaleChangeType
@export var texture_scale_loop : LoopType

var texture_scale_cache : PackedFloat32Array
var texture_scale_max_tick : int

## Rotate texture base on direction. This overwrite Texture Rotation Speed

@export_subgroup("Animation")
@export var use_animation : bool = false
@export var animated_sprite : SpriteFrames
@export var animation_name : String


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

@export_group("Move speed Change")

enum MoveSpeedChangeType{
	MULTIPLIER, 
	HARD_VALUE, 
}

enum LoopType {
	ONCE_AND_KEEP, 
	LOOP_FROM_START, 
	PING_PONG,
}

@export var is_move_speed_change : bool = false

@export_subgroup("Curve")
@export var is_move_speed_change_curve : bool = false
@export var move_speed_change_type : MoveSpeedChangeType
@export var move_speed_change_loop : LoopType
@export var move_speed_curve : Curve
# @export var is_caching_move_speed_change : bool = true

var move_speed_curve_cache : Array[float]
var move_speed_curve_max_tick : int



@export_subgroup("Math Equation")
@export var is_move_speed_change_math : bool = false
## Time : t
@export_multiline var move_speed_math_equation : String
@export var move_speed_math_max_time : float = 1.0
@export var move_speed_math_type : MoveSpeedChangeType
@export var move_speed_math_loop : LoopType

var move_speed_math_cache : PackedFloat32Array
var move_speed_math_max_tick : int


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


@export_group("Homing")

enum HomingTargetType{
	FIXED_POSITION,
	GROUP,
	SPECIAL_NODE,
	NODE_PATH,
	MOUSE_POSITION
}
enum HomingGroupSelection{
	NEAREST,
	RANDOM,
}
@export var is_homing: bool = false

@export var homing_steer_speed : float = 10.0

@export var homing_delay_time : float
@export var homing_delay_distance : float

@export var homing_stop_time : float
@export var homing_stop_distance : float


@export var homing_target_type : HomingTargetType
@export_subgroup("Target Type")
@export var homing_fixed_position: Vector2
@export var homing_group: String
@export var homing_group_seletion: HomingGroupSelection
@export var homing_special_node_id : String


var bullet_area_rid : RID


# func _enter_tree() -> void:
# 	if !collision_shape:
# 		collision_shape = CircleShape2D.new()

# func _ready() -> void:
# 	BulletHell.template_nodes.get_or_add(template_id, self)

func caching_texture_scale_curve_value() -> void:
	if !is_texture_scale_change: return
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	texture_scale_max_tick = int(texture_scale_curve.max_domain / _tick_time)
	for i in range(texture_scale_max_tick):
		texture_scale_cache.append(texture_scale_curve.sample(_tick_time * i))

func caching_move_speed_change() -> void:
	if !is_move_speed_change: return
	if is_move_speed_change_curve:
		caching_move_speed_curve_value()
	if is_move_speed_change_math:
		caching_move_speed_math_value() 
	pass

func caching_move_speed_curve_value() -> void:
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	move_speed_curve_max_tick = int(move_speed_curve.max_domain / _tick_time)
	for i in range(move_speed_curve_max_tick):
		move_speed_curve_cache.append(move_speed_curve.sample(_tick_time * i))
	pass


func caching_move_speed_math_value() -> void:
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	var _expression := Expression.new()
	move_speed_math_max_tick = int(move_speed_math_max_time / _tick_time)

	var _result : Variant
	_expression.parse(move_speed_math_equation, ["t"])
	for i in range(move_speed_math_max_tick + 1):
		_result = _expression.execute([_tick_time * i])
		if _result:
			move_speed_math_cache.append(_result)
