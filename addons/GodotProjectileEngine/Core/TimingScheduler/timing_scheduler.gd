extends Resource
class_name TimingScheduler

signal timing_timed
signal scheduler_completed


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

@export var timing_wave : Array[TimingWave]

@export var loop_type : LOOP_TYPE = LOOP_TYPE.LOOP_FROM_START
@export var loop_amout : int = -1

@export var destroy_after_finish : bool = false

@export_group("Start delay")
@export var do_start_delay : bool = false
@export var start_delay_time : float = 1.0
@export var is_rand_start_delay : bool = false
@export var start_delay_min : float = 0.0
@export var start_delay_max : float = 2.0


var start_delay_timer : Timer

var shoot_cooldown_timer: Timer
var shoot_cooldown_time : float = 2


var loop_count : int



# # func _enter_tree() -> void:
# # 	if timing_wave: return
# # 	var bullet_timing_wave := TimingWave.new()
# # 	bullet_timing_wave.timing_wave = [1.0]
# # 	timing_wave = [bullet_timing_wave]

# # func _ready() -> void:
# # 	setup_shoot_cooldown_timer()
# # 	if do_start_delay:
# # 		setup_start_delay_timer()
# # 	else:
# # 		start_next_interval()


var timing_wave_index : int = 0
var timing_wave_index_direction : int

func get_next_timing_wave() -> TimingWave:

	if loop_amout > 0:
		if loop_count >= loop_amout:
			scheduler_completed.emit()
			shoot_cooldown_timer.stop()
			return null
		loop_count += 1

	var _next_timing_wave : TimingWave

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
			for wave : TimingWave in timing_wave:
				weight_array.append(wave.weight)
			_next_timing_wave = timing_wave[_rand.rand_weighted(weight_array)]


	return _next_timing_wave


# var timing_interval : Array[float] = []

# func start_next_interval() -> void:
# 	if timing_interval.size() == 0:
# 		var _timing_wave := get_next_timing_wave()
# 		if ! _timing_wave: return
# 		timing_interval.append_array(_timing_wave.timing_wave)

# 	spawn_timed.emit()

# 	shoot_cooldown_timer.start(timing_interval.pop_front())


# func stop_scheduler() -> void:
# 	shoot_cooldown_timer.stop()
# 	timing_interval.clear()
# 	pass

# func setup_shoot_cooldown_timer() -> void:
# 	shoot_cooldown_timer = Timer.new()
# 	shoot_cooldown_timer.autostart = false
# 	shoot_cooldown_timer.one_shot = true
# 	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout)
# 	add_child(shoot_cooldown_timer)

# func _on_shoot_cooldown_timer_timeout() -> void:
# 	start_next_interval()
# 	pass



# func setup_start_delay_timer() -> void:
# 	start_delay_timer = Timer.new()
# 	start_delay_timer.autostart = true
# 	start_delay_timer.one_shot = true
# 	if is_rand_start_delay:
# 		start_delay_time = randf_range(start_delay_min, start_delay_max)

# 	start_delay_timer.wait_time = start_delay_time
# 	start_delay_timer.timeout.connect(_on_start_delay_timer_timeout)
# 	add_child(start_delay_timer)
	
# func _on_start_delay_timer_timeout() -> void:

# 	start_next_interval()
# 	pass



# #region Scheduler

# var start_delay_timer : Timer
# var shoot_cooldown_timer: Timer

# var timing_wave_index : int = 0
# var timing_wave_index_direction : int
# var loop_count: int 



# func setup_bullet_scheduler() -> void:
# 	if !shoot_cooldown_timer:
# 		setup_shoot_cooldown_timer()
# 	if !spawn_timed.is_connected(spawn_pattern):
# 		spawn_timed.connect(spawn_pattern)

# 	if bullet_scheduler.do_start_delay:
# 		if !start_delay_timer:  
# 			setup_start_delay_timer()
# 		start_delay_timer.start()
# 	else:
# 		start_next_scheduler_timing_interval()

# 	if !scheduler_completed.is_connected(_on_bullet_scheduler_completed):
# 		scheduler_completed.connect(_on_bullet_scheduler_completed)

# 	if bullet_scheduler.destroy_after_finish:
# 		scheduler_completed.connect(queue_free)

# 	pass

# func _on_bullet_scheduler_completed() -> void:
# 	if bullet_scheduler.destroy_after_finish:
# 		queue_free()
# 	active = false

# 	pass

# func disconnect_bullet_scheduler() -> void:
# 	if !shoot_cooldown_timer: return

# 	shoot_cooldown_timer.stop()
# 	if start_delay_timer:
# 		start_delay_timer.stop()
# 		pass
# 	scheduler_completed.disconnect(_on_bullet_scheduler_completed)
# 	spawn_timed.disconnect(spawn_pattern)
# 	pass


# func clear_bullet_spawner() -> void:
# 	if shoot_cooldown_timer:
# 		shoot_cooldown_timer.queue_free()
# 	if start_delay_timer:
# 		start_delay_timer.queue_free()
# 	timing_wave_index = 0
# 	timing_wave_index_direction = 0

# func get_next_scheduler_timing_wave() -> TimingWave:
# 	if bullet_scheduler.loop_amout > 0:
# 		if loop_count >= bullet_scheduler.loop_amout:
# 			scheduler_completed.emit()
# 			shoot_cooldown_timer.stop()
# 			return null
# 		loop_count += 1

# 	var _next_timing_wave : TimingWave

# 	match bullet_scheduler.loop_type:
# 		0: #LOOP_TYPE.ONE_AND_KEEP
# 			_next_timing_wave = bullet_scheduler.timing_wave[timing_wave_index]
# 			if timing_wave_index <  bullet_scheduler.timing_wave.size() - 1:
# 				timing_wave_index += 1

# 		1: #LOOP_TYPE.LOOP_FROM_START:
# 			_next_timing_wave = bullet_scheduler.timing_wave[timing_wave_index]

# 			if timing_wave_index == bullet_scheduler.timing_wave.size() - 1:
# 				timing_wave_index = 0
# 			else:
# 				timing_wave_index += 1
# 		2: #LOOP_TYPE.LOOP_FROM_END:
# 			_next_timing_wave = bullet_scheduler.timing_wave[timing_wave_index]
# 			if bullet_scheduler.timing_wave.size() == 1:
# 				timing_wave_index_direction = 0
# 			elif timing_wave_index ==  bullet_scheduler.timing_wave.size() - 1:
# 				timing_wave_index_direction = -1
# 			elif timing_wave_index == 0:
# 				timing_wave_index_direction = 1
# 			timing_wave_index += timing_wave_index_direction

# 		3: #LOOP_TYPE.RANDOM:
# 			_next_timing_wave = bullet_scheduler.timing_wave.pick_random()

# 		4: #LOOP_TYPE.RANDOM_WEIGHTED:
# 			var _rand: = RandomNumberGenerator.new()
# 			var weight_array := []
# 			for wave : TimingWave in bullet_scheduler.timing_wave:
# 				weight_array.append(wave.weight)
# 			_next_timing_wave = bullet_scheduler.timing_wave[_rand.rand_weighted(weight_array)]


# 	return _next_timing_wave


# var timing_interval : Array[float] = []

# func start_next_scheduler_timing_interval() -> void:
# 	if timing_interval.size() == 0:
# 		var _timing_wave := get_next_scheduler_timing_wave()
# 		if ! _timing_wave: return
# 		timing_interval.append_array(_timing_wave.timing_wave)

# 	spawn_timed.emit()
# 	shoot_cooldown_timer.start(timing_interval.pop_front())

# func reset_scheduler_interval() -> void:
# 	timing_interval.clear()
# 	timing_wave_index = 0
# 	loop_count = 0
# 	pass


# func stop_scheduler() -> void:
# 	shoot_cooldown_timer.stop()
# 	timing_interval.clear()
# 	pass

# func setup_shoot_cooldown_timer() -> void:
# 	if shoot_cooldown_timer: return
# 	shoot_cooldown_timer = Timer.new()
# 	shoot_cooldown_timer.autostart = false
# 	shoot_cooldown_timer.one_shot = true
# 	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout)
# 	add_child(shoot_cooldown_timer)

# func _on_shoot_cooldown_timer_timeout() -> void:
# 	start_next_scheduler_timing_interval()
# 	pass


# func setup_start_delay_timer() -> void:
# 	if start_delay_timer: return

# 	start_delay_timer = Timer.new()
# 	start_delay_timer.autostart = false
# 	start_delay_timer.one_shot = true

# 	if bullet_scheduler.is_rand_start_delay:
# 		bullet_scheduler.start_delay_time = randf_range(bullet_scheduler.start_delay_min, bullet_scheduler.start_delay_max)
# 	start_delay_timer.wait_time = bullet_scheduler.start_delay_time

# 	start_delay_timer.timeout.connect(_on_start_delay_timer_timeout)

# 	add_child(start_delay_timer)
	
# func _on_start_delay_timer_timeout() -> void:

# 	start_next_scheduler_timing_interval()
# 	pass

# #endregion
