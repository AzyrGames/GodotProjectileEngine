extends BTCBase
class_name BTCSpeed

enum MoveSpeedChangeType{
	MULTIPLIER, 
	HARD_VALUE, 
}

enum LoopType {
	ONCE_AND_KEEP, 
	LOOP_FROM_START, 
	PING_PONG,
}

@export var move_speed_change_type : MoveSpeedChangeType
@export var move_speed_change_loop : LoopType
@export var move_speed_curve : Curve
# @export var is_caching_move_speed_change : bool = true

var _is_cached : bool = false

var move_speed_curve_cache : Array[float]
var move_speed_curve_max_tick : int

var _speed_change_sample : int
var _speed_change_sample_value : float 

func _init() -> void:
	pass

func process_template(active_bullet_instances: Array[BulletInstance2D]) -> void:
	if !is_active: return 
	if active_bullet_instances.size() <= 0:
		return
	
	if !_is_cached:
		caching_move_speed_curve_value()

	for _bullet_instance in active_bullet_instances:
		_speed_change_sample = _bullet_instance.life_time_tick
		if _speed_change_sample >= move_speed_curve_max_tick:
			_speed_change_sample = move_speed_curve_max_tick - 1
		_speed_change_sample_value = move_speed_curve_cache[_speed_change_sample]

		_bullet_instance.move_speed_modifier = _speed_change_sample_value


	# match move_speed_change_loop:
	# 	0: #BulletTemplate2D.LoopType.ONCE_AND_KEEP:
	# 		if _bullet_instance.life_time_tick < _move_speed_curve_max_tick:
	# 			_speed_change_sample = _bullet_instance.life_time_tick
	# 		else:
	# 			_speed_change_sample = _move_speed_curve_max_tick - 1
	# 	1: #BulletTemplate2D.LoopType.LOOP_FROM_START:
	# 		_speed_change_sample =_bullet_instance.life_time_tick % _move_speed_curve_max_tick
	# 		pass
	# 	2: #BulletTemplate2D.LoopType.PING_PONG:
	# 		pass

	# _speed_change_sample_value = _move_speed_curve_cache[_speed_change_sample]
	
	# match _move_speed_change_type:
	# 	0:
	# 		_bullet_instance.move_speed = _bullet_instance.base_move_speed * _speed_change_sample_value
	# 		pass
	# 	1:
	# 		_bullet_instance.move_speed = _speed_change_sample_value
	# 		pass



	pass


func caching_move_speed_curve_value() -> void:
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	move_speed_curve_max_tick = int(move_speed_curve.max_domain / _tick_time)
	for i in range(move_speed_curve_max_tick):
		move_speed_curve_cache.append(move_speed_curve.sample(_tick_time * i))
	
	_is_cached = true
	pass

# enum TextureScaleChangeType{
# 	MULTIPLIER, 
# 	HARD_VALUE, 
# }
# @export var texture_rotation_speed : float = 0.0

# @export var is_texture_scale_change : bool = false
# @export var texture_scale_curve : Curve
# @export var texture_scale_type : TextureScaleChangeType
# @export var texture_scale_loop : LoopType

# var texture_scale_cache : PackedFloat32Array
# var texture_scale_max_tick : int



# @export_group("Move speed Change")

# enum MoveSpeedChangeType{
# 	MULTIPLIER, 
# 	HARD_VALUE, 
# }

# enum LoopType {
# 	ONCE_AND_KEEP, 
# 	LOOP_FROM_START, 
# 	PING_PONG,
# }

# @export var is_move_speed_change : bool = false

# @export_subgroup("Curve")
# @export var is_move_speed_change_curve : bool = false
# @export var move_speed_change_type : MoveSpeedChangeType
# @export var move_speed_change_loop : LoopType
# @export var move_speed_curve : Curve
# # @export var is_caching_move_speed_change : bool = true

# var move_speed_curve_cache : Array[float]
# var move_speed_curve_max_tick : int



# @export_subgroup("Math Equation")
# @export var is_move_speed_change_math : bool = false
# ## Time : t
# @export_multiline var move_speed_math_equation : String
# @export var move_speed_math_max_time : float = 1.0
# @export var move_speed_math_type : MoveSpeedChangeType
# @export var move_speed_math_loop : LoopType

# var move_speed_math_cache : PackedFloat32Array
# var move_speed_math_max_tick : int


# @export_group("Move Direction Change")
# enum MoveDirectionChangeType{
# 	ROTATION, ## The Direction Change will keep related to the original Move Direction
# 	HARD_DIRECTION, ## Overrite the current Move Direction with curve Direcion
# 	HARD_POSITION, ## Overrite the current position with curve Position

# }

# @export var is_move_direction_change : bool = false
# @export var move_direction_change_type : MoveDirectionChangeType
# @export var move_direction_change_loop : LoopType
# @export var move_direction_curve2d : Curve2D 


# @export_group("Homing")

# enum HomingTargetType{
# 	FIXED_POSITION,
# 	GROUP,
# 	SPECIAL_NODE,
# 	NODE_PATH,
# 	MOUSE_POSITION
# }
# enum HomingGroupSelection{
# 	NEAREST,
# 	RANDOM,
# }
# @export var is_homing: bool = false

# @export var homing_steer_speed : float = 10.0

# @export var homing_delay_time : float
# @export var homing_delay_distance : float

# @export var homing_stop_time : float
# @export var homing_stop_distance : float


# @export var homing_target_type : HomingTargetType
# @export_subgroup("Target Type")
# @export var homing_fixed_position: Vector2
# @export var homing_group: String
# @export var homing_group_seletion: HomingGroupSelection
# @export var homing_special_node_id : String

# func caching_texture_scale_curve_value() -> void:
# 	if !is_texture_scale_change: return
# 	var _tick_time := 1.0 / Engine.physics_ticks_per_second
# 	texture_scale_max_tick = int(texture_scale_curve.max_domain / _tick_time)
# 	for i in range(texture_scale_max_tick):
# 		texture_scale_cache.append(texture_scale_curve.sample(_tick_time * i))

# func caching_move_speed_change() -> void:
# 	if !is_move_speed_change: return
# 	if is_move_speed_change_curve:
# 		caching_move_speed_curve_value()
# 	if is_move_speed_change_math:
# 		caching_move_speed_math_value() 
# 	pass

# func caching_move_speed_curve_value() -> void:
# 	var _tick_time := 1.0 / Engine.physics_ticks_per_second
# 	move_speed_curve_max_tick = int(move_speed_curve.max_domain / _tick_time)
# 	for i in range(move_speed_curve_max_tick):
# 		move_speed_curve_cache.append(move_speed_curve.sample(_tick_time * i))
# 	pass


# func caching_move_speed_math_value() -> void:
# 	var _tick_time := 1.0 / Engine.physics_ticks_per_second
# 	var _expression := Expression.new()
# 	move_speed_math_max_tick = int(move_speed_math_max_time / _tick_time)

# 	var _result : Variant
# 	_expression.parse(move_speed_math_equation, ["t"])
# 	for i in range(move_speed_math_max_tick + 1):
# 		_result = _expression.execute([_tick_time * i])
# 		if _result:
# 			move_speed_math_cache.append(_result)


# var _texture_scale_sample : float
# var _texture_scale_sample_value: float
# var _is_texture_scale_change : bool
# var _texture_scale_max_tick : int
# var _texture_scale_cache : PackedFloat32Array
# var _texture_scale_type : int
# var _texture_scale_loop : int


# var _speed_change_sample: float
# var _speed_change_sample_value: float
# var _move_speed_curve_max_tick : int 
# var _move_speed_curve_cache : PackedFloat32Array 
# var _move_speed_change_type : BulletTemplate2D.MoveSpeedChangeType 
# var _is_move_speed_change : bool 
# # var _is_caching_move_speed_change := bullet_template_2d.is_caching_move_speed_change
# var _move_speed_change_loop : BulletTemplate2D.LoopType 


# var _is_move_speed_change_math : int 
# var _move_speed_math_max_tick :int 
# var _move_speed_math_cache : PackedFloat32Array 
# var _move_speed_math_type : BulletTemplate2D.MoveSpeedChangeType 
# var _move_speed_math_loop : BulletTemplate2D.LoopType 


# var _is_move_direction_change : bool 
# var _move_direction_curve2d : Curve2D 
# var _move_direction_change_loop : BulletTemplate2D.LoopType 
# var _move_direction_change_type : BulletTemplate2D.MoveDirectionChangeType 


# var _move_direction_sample: float 
# var _baked_rotation : Transform2D

# var _is_homing : bool 
# var _homing_target_type : BulletTemplate2D.HomingTargetType 
# var _homing_target_position : Vector2 
# var _homing_target_direction : Vector2 
# var _homing_fixed_position : Vector2 
# var _homing_steer_speed : float  
# var _homing_target_nodes : Array 
# var _homing_special_nodes : Array
# var _homing_distance_check : float 
# var _homing_distance_check_value : float 

	# _is_texture_scale_change = bullet_template_2d.is_texture_scale_change
	# if _is_texture_scale_change:
	# 	_texture_scale_max_tick = bullet_template_2d.texture_scale_max_tick
	# 	_texture_scale_cache = bullet_template_2d.texture_scale_cache
	# 	_texture_scale_type = bullet_template_2d.texture_scale_type
	# 	_texture_scale_loop = bullet_template_2d.texture_scale_loop


	# _is_move_speed_change  = bullet_template_2d.is_move_speed_change
	# if _is_move_speed_change:
	# 	_move_speed_curve_max_tick  = bullet_template_2d.move_speed_curve_max_tick
	# 	_move_speed_curve_cache  = bullet_template_2d.move_speed_curve_cache
	# 	_move_speed_change_type  = bullet_template_2d.move_speed_change_type
	# 	_move_speed_change_loop = bullet_template_2d.move_speed_change_loop

	# _is_move_speed_change_math  = bullet_template_2d.is_move_speed_change_math
	# if _is_move_speed_change_math:
	# 	_move_speed_math_max_tick  = bullet_template_2d.move_speed_math_max_tick
	# 	_move_speed_math_cache  = bullet_template_2d.move_speed_math_cache
	# 	_move_speed_math_type  = bullet_template_2d.move_speed_math_type
	# 	_move_speed_math_loop  = bullet_template_2d.move_speed_math_loop

	# _is_move_direction_change = bullet_template_2d.is_move_direction_change
	# if _is_move_direction_change:
	# 	_move_direction_curve2d = bullet_template_2d.move_direction_curve2d
	# 	_move_direction_change_loop = bullet_template_2d.move_direction_change_loop
	# 	_move_direction_change_type = bullet_template_2d.move_direction_change_type


	# _is_homing = bullet_template_2d.is_homing
	# if _is_homing:
	# 	_homing_target_type = bullet_template_2d.homing_target_type
	# 	_homing_target_position = Vector2.ZERO
	# 	_homing_target_direction = Vector2.ZERO
	# 	_homing_fixed_position = bullet_template_2d.homing_fixed_position
	# 	_homing_steer_speed = bullet_template_2d.homing_steer_speed
	# 	_homing_target_nodes = get_tree().get_nodes_in_group("HomingTarget")
	# 	_homing_special_nodes = BulletHell.bullet_homing_targets[bullet_template_2d.homing_special_node_id]
	# 	_homing_distance_check = 0.0
	# 	_homing_distance_check_value = 0.0