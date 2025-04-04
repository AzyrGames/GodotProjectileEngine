extends Node
class_name BulletScheduler

enum LOOP_TYPE {
	ONE_AND_KEEP,
	LOOP_FROM_START,
	LOOP_FROM_END,
	RANDOM,
	RANDOM_WEIGHTED,
}



enum DURATION_TYPE {
	AMOUNT,
	TIME,
	FRAME,
}

@export var timing_wave : Array[BulletTimingWave]



@export var loop_type : LOOP_TYPE = LOOP_TYPE.LOOP_FROM_START
@export var loop_amout : int = -1
var loop_count : int


var start_delay_timer : Timer
var start_delay_time : = 0.5

var shoot_cooldown_timer: Timer
var shoot_cooldown_time : float = 2


signal spawn_timed

signal scheduler_completed


func _ready() -> void:
	setup_shoot_cooldown_timer()
	start_next_interval()



func _physics_process(delta: float) -> void:
	pass

var timing_wave_index : int = 0
var timing_wave_index_direction : int

func get_next_timing_wave() -> BulletTimingWave:

	if loop_amout > 0:
		if loop_count >= loop_amout:
			scheduler_completed.emit()
			shoot_cooldown_timer.stop()
			return null
		loop_count += 1

	var _next_timing_wave : BulletTimingWave

	match loop_type:
		LOOP_TYPE.ONE_AND_KEEP:
			_next_timing_wave = timing_wave[timing_wave_index]
			if timing_wave_index <  timing_wave.size() - 1:
				timing_wave_index += 1

		LOOP_TYPE.LOOP_FROM_START:
			_next_timing_wave = timing_wave[timing_wave_index]

			if timing_wave_index == timing_wave.size() - 1:
				timing_wave_index = 0
			else:
				timing_wave_index += 1
		LOOP_TYPE.LOOP_FROM_END:
			_next_timing_wave = timing_wave[timing_wave_index]
			if timing_wave.size() == 1:
				timing_wave_index_direction = 0
			elif timing_wave_index ==  timing_wave.size() - 1:
				timing_wave_index_direction = -1
			elif timing_wave_index == 0:
				timing_wave_index_direction = 1
			timing_wave_index += timing_wave_index_direction

		LOOP_TYPE.RANDOM:
			_next_timing_wave = timing_wave.pick_random()

		LOOP_TYPE.RANDOM_WEIGHTED:
			var _rand: = RandomNumberGenerator.new()
			var weight_array := []
			for wave : BulletTimingWave in timing_wave:
				weight_array.append(wave.weight)
			_next_timing_wave = timing_wave[_rand.rand_weighted(weight_array)]


	return _next_timing_wave


var timing_interval : Array[float] = []

func start_next_interval() -> void:
	if timing_interval.size() == 0:
		var _timing_wave := get_next_timing_wave()
		if ! _timing_wave: return
		timing_interval.append_array(_timing_wave.timing_wave)

	spawn_timed.emit()

	shoot_cooldown_timer.start(timing_interval.pop_front())

func setup_shoot_cooldown_timer() -> void:
	shoot_cooldown_timer = Timer.new()
	shoot_cooldown_timer.autostart = false
	shoot_cooldown_timer.one_shot = true
	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout)
	add_child(shoot_cooldown_timer)

func _on_shoot_cooldown_timer_timeout() -> void:
	start_next_interval()
	pass



func setup_start_delay_timer() -> void:
	start_delay_timer = Timer.new()
	start_delay_timer.autostart = true
	start_delay_timer.one_shot = true
	start_delay_timer.wait_time = start_delay_time
	start_delay_timer.timeout.connect(_on_start_delay_timer_timeout)
	add_child(start_delay_timer)
	
func _on_start_delay_timer_timeout() -> void:
	# start_bullet_pattern_scheduler()
	pass

# func setup_duration_timer() -> void:
# 	duration_timer = Timer.new()
# 	duration_timer.autostart = true
# 	duration_timer.one_shot = true
# 	duration_timer.wait_time = duration_value
# 	duration_timer.timeout.connect(_on_duration_timer_timeout)
# 	add_child(duration_timer)
	

# func _on_duration_timer_timeout() -> void:
# 	scheduler_stopped.emit()
# 	duration_value = 0.0
# 	shot_interval_timer.stop()
# 	shot_interval_timer.queue_free()
# 	duration_timer.queue_free()
# 	is_active = false
	

# func setup_shot_interval_timer() -> void:
# 	shot_interval_timer = Timer.new()
# 	shot_interval_timer.autostart = true
# 	shot_interval_timer.one_shot = true
# 	#if bullet_pattern_scheduler.interval_values.size() <= 0:
# 		#bullet_pattern_scheduler.interval_values.append(0.05)
# 	current_interval_index = 0
# 	shot_interval_timer.wait_time = bullet_pattern_scheduler.interval_values[current_interval_index]
# 	shot_interval_timer.timeout.connect(_on_shot_interval_timeout)
# 	add_child(shot_interval_timer)
	

# func _on_shot_interval_timeout() -> void:
	
# 	if bullet_pattern_scheduler.durration_type == bullet_pattern_scheduler.DURATION_TYPE.AMOUNT:
# 		duration_value -= 1

# 	if duration_value <= 0:
# 		shot_interval_timer.queue_free()
# 		scheduler_stopped.emit()
# 		return

# 	pattern_spawned.emit()



# 	match bullet_pattern_scheduler.interval_loop_type:
# 		bullet_pattern_scheduler.LOOP_TYPE.ONE_AND_KEEP:
# 			if current_interval_index <  bullet_pattern_scheduler.interval_values.size() - 1:
# 				current_interval_index += 1
# 		bullet_pattern_scheduler.LOOP_TYPE.LOOP_FROM_START:
# 			if current_interval_index ==  bullet_pattern_scheduler.interval_values.size() - 1:
# 				current_interval_index = 0
# 			else:
# 				current_interval_index += 1
# 		bullet_pattern_scheduler.LOOP_TYPE.LOOP_FROM_END:
# 			if current_interval_index ==  bullet_pattern_scheduler.interval_values.size() - 1:
# 				interval_index_direction = -1
# 			elif current_interval_index == 0:
# 				interval_index_direction = 1
# 			current_interval_index += interval_index_direction

# 	shot_interval_timer.wait_time = bullet_pattern_scheduler.interval_values[current_interval_index]
# 	shot_interval_timer.start()
