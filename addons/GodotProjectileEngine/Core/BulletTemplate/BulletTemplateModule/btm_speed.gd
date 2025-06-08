extends BulletTemplateModule
class_name BTMSpeed

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
		match move_speed_change_loop:
			0: #BulletTemplate2D.LoopType.ONCE_AND_KEEP:
				if _bullet_instance.life_time_tick < move_speed_curve_max_tick:
					_speed_change_sample = _bullet_instance.life_time_tick
				else:
					_speed_change_sample = move_speed_curve_max_tick - 1
			1: #BulletTemplate2D.LoopType.LOOP_FROM_START:
				_speed_change_sample =_bullet_instance.life_time_tick % move_speed_curve_max_tick
				pass
			2: #BulletTemplate2D.LoopType.PING_PONG:
				_speed_change_sample = _bullet_instance.life_time_tick % move_speed_curve_max_tick * sign(pow(-1, int(_bullet_instance.life_time_tick / move_speed_curve_max_tick + 1)))

				pass
		
		_speed_change_sample_value = move_speed_curve_cache[_speed_change_sample]

		match move_speed_change_type:
			0:
				_bullet_instance.move_speed_modifier = _speed_change_sample_value
				pass
			1:
				_bullet_instance.move_speed_modifier = 0.0 
				_bullet_instance.move_speed_static = _speed_change_sample_value
				pass
	pass


func caching_move_speed_curve_value() -> void:
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	move_speed_curve_cache.clear()
	move_speed_curve_max_tick = int(move_speed_curve.max_domain / _tick_time)
	for i in range(move_speed_curve_max_tick):
		move_speed_curve_cache.append(move_speed_curve.sample(_tick_time * i))
	_is_cached = true
	pass