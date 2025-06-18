extends ProjectileBehaviorSpeed
class_name ProjectileSpeedCurve


enum LoopMethod {
	ONCE_AND_DONE, ## Loop Once and keep the last value
	LOOP_FROM_START, ## Loop start to end and restart
	LOOP_FROM_END, ## Ping pong
}


@export var speed_modify_method : SpeedModifyMethod = SpeedModifyMethod.MULTIPLIER
@export var speed_curve_loop_method : LoopMethod = LoopMethod.ONCE_AND_DONE
@export var speed_curve_sample_method : SampleMethod = SampleMethod.LIFE_TIME_SECOND
@export var speed_curve : Curve

var _is_cached : bool = false

var speed_curve_cache : Array[float]
var speed_curve_max_tick : int

var _speed_curve_sample : float
var _speed_curve_sample_value : float
var _result_value : float


func behavior_context_request() -> Array[ProjectileEngine.BehviorContext]:
	return [
		ProjectileEngine.BehviorContext.LIFE_TIME_SECOND,
		ProjectileEngine.BehviorContext.BASE_SPEED
		]
	pass


func process_behavior(_value: float, _context: Dictionary) -> float:
	if !_is_cached:
		caching_speed_curve_value()
	if not _context.has(ProjectileEngine.BehviorContext.LIFE_TIME_SECOND): return _value
	var _context_life_time_second := _context.get(ProjectileEngine.BehviorContext.LIFE_TIME_SECOND) as float

	match speed_curve_loop_method:
		LoopMethod.ONCE_AND_DONE:
			_speed_curve_sample = _context_life_time_second
			pass
		LoopMethod.LOOP_FROM_START:
			_speed_curve_sample = fmod(_context_life_time_second, speed_curve.max_domain)
			pass
		LoopMethod.LOOP_FROM_END:
			_speed_curve_sample = fmod(_context_life_time_second, speed_curve.max_domain) * sign(pow(-1, int(_context_life_time_second / speed_curve.max_domain + 1)))
			pass

	_speed_curve_sample_value = speed_curve.sample_baked(_speed_curve_sample)
	
	match speed_modify_method:
		SpeedModifyMethod.ADDTITION:
			if !_context.has(ProjectileEngine.BehviorContext.BASE_SPEED): _result_value = _value
			_result_value = _context.get(ProjectileEngine.BehviorContext.BASE_SPEED) + _speed_curve_sample_value
			pass
		SpeedModifyMethod.MULTIPLIER:
			if !_context.has(ProjectileEngine.BehviorContext.BASE_SPEED): _result_value = _value
			_result_value = _context.get(ProjectileEngine.BehviorContext.BASE_SPEED) * _speed_curve_sample_value
			pass
		SpeedModifyMethod.OVERRIDE:
			_result_value = _speed_curve_sample_value
			pass
	return _result_value


func caching_speed_curve_value() -> void:
	var _tick_time := 1.0 / Engine.physics_ticks_per_second
	speed_curve_cache.clear()
	speed_curve_max_tick = int(speed_curve.max_domain / _tick_time)
	for i in range(speed_curve_max_tick):
		speed_curve_cache.append(speed_curve.sample(_tick_time * i))
	_is_cached = true
	pass
