# extends TimingScheduler
# class_name TimingSchedulerDefault

# enum LOOP_TYPE {
# 	ONE_AND_KEEP,
# 	LOOP_FROM_START,
# 	LOOP_FROM_END,
# 	RANDOM,
# 	RANDOM_WEIGHTED,
# }

# enum DURATION_TYPE {
# 	AMOUNT,
# 	TIME,
# 	FRAME,
# }

# @export var timing_wave : Array[TimingWave]

# @export var loop_type : LOOP_TYPE = LOOP_TYPE.LOOP_FROM_START
# @export var loop_amout : int = -1


# @export_group("Start delay")
# @export var do_start_delay : bool = false
# @export var start_delay_time : float = 0.5
# @export var is_rand_start_delay : bool = false
# @export var start_delay_min : float = 0.0
# @export var start_delay_max : float = 2.0


# var start_delay_timer : Timer

# var shoot_cooldown_timer: Timer
# var shoot_cooldown_time : float = 2


# var loop_count : int



# # # func _enter_tree() -> void:
# # # 	if timing_wave: return
# # # 	var projectile_timing_wave := TimingWave.new()
# # # 	projectile_timing_wave.timing_wave = [1.0]
# # # 	timing_wave = [projectile_timing_wave]

# # # func _ready() -> void:
# # # 	setup_shoot_cooldown_timer()
# # # 	if do_start_delay:
# # # 		setup_start_delay_timer()
# # # 	else:
# # # 		start_next_interval()


# var timing_wave_index : int = 0
# var timing_wave_index_direction : int

# func get_next_timing_wave() -> TimingWave:

# 	if loop_amout > 0:
# 		if loop_count >= loop_amout:
# 			scheduler_completed.emit()
# 			shoot_cooldown_timer.stop()
# 			return null
# 		loop_count += 1

# 	var _next_timing_wave : TimingWave

# 	match loop_type:
# 		LOOP_TYPE.ONE_AND_KEEP:
# 			_next_timing_wave = timing_wave[timing_wave_index]
# 			if timing_wave_index <  timing_wave.size() - 1:
# 				timing_wave_index += 1

# 		LOOP_TYPE.LOOP_FROM_START:
# 			_next_timing_wave = timing_wave[timing_wave_index]

# 			if timing_wave_index == timing_wave.size() - 1:
# 				timing_wave_index = 0
# 			else:
# 				timing_wave_index += 1
# 		LOOP_TYPE.LOOP_FROM_END:
# 			_next_timing_wave = timing_wave[timing_wave_index]
# 			if timing_wave.size() == 1:
# 				timing_wave_index_direction = 0
# 			elif timing_wave_index ==  timing_wave.size() - 1:
# 				timing_wave_index_direction = -1
# 			elif timing_wave_index == 0:
# 				timing_wave_index_direction = 1
# 			timing_wave_index += timing_wave_index_direction

# 		LOOP_TYPE.RANDOM:
# 			_next_timing_wave = timing_wave.pick_random()

# 		LOOP_TYPE.RANDOM_WEIGHTED:
# 			var _rand: = RandomNumberGenerator.new()
# 			var weight_array := []
# 			for wave : TimingWave in timing_wave:
# 				weight_array.append(wave.weight)
# 			_next_timing_wave = timing_wave[_rand.rand_weighted(weight_array)]


# 	return _next_timing_wave


# # var timing_interval : Array[float] = []

# # func start_next_interval() -> void:
# # 	if timing_interval.size() == 0:
# # 		var _timing_wave := get_next_timing_wave()
# # 		if ! _timing_wave: return
# # 		timing_interval.append_array(_timing_wave.timing_wave)

# # 	spawn_timed.emit()

# # 	shoot_cooldown_timer.start(timing_interval.pop_front())


# # func stop_scheduler() -> void:
# # 	shoot_cooldown_timer.stop()
# # 	timing_interval.clear()
# # 	pass

# # func setup_shoot_cooldown_timer() -> void:
# # 	shoot_cooldown_timer = Timer.new()
# # 	shoot_cooldown_timer.autostart = false
# # 	shoot_cooldown_timer.one_shot = true
# # 	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout)
# # 	add_child(shoot_cooldown_timer)

# # func _on_shoot_cooldown_timer_timeout() -> void:
# # 	start_next_interval()
# # 	pass



# # func setup_start_delay_timer() -> void:
# # 	start_delay_timer = Timer.new()
# # 	start_delay_timer.autostart = true
# # 	start_delay_timer.one_shot = true
# # 	if is_rand_start_delay:
# # 		start_delay_time = randf_range(start_delay_min, start_delay_max)

# # 	start_delay_timer.wait_time = start_delay_time
# # 	start_delay_timer.timeout.connect(_on_start_delay_timer_timeout)
# # 	add_child(start_delay_timer)
	
# # func _on_start_delay_timer_timeout() -> void:

# # 	start_next_interval()
# # 	pass
