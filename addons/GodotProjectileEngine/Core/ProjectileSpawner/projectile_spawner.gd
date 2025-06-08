# @tool
extends Node2D
class_name BulletSpawner2D

@export var active : bool = true:
	set(value):
		if value:
			activate_bullet_spawner()
		else:
			deactive_bullet_spanwer()
		active = value

var bullet_area : RID

@export var bullet_composer_name : String
var bullet_composer : PatternComposer2D

@export var bullet_template_2d : ProjectileTemplate2D
@export var bullet_scheduler : TimingScheduler

@export var audio_stream: AudioStreamPlayer

var pattern_packs: Array

var start_delay_timer : Timer
var shoot_cooldown_timer: Timer

var timing_wave_index : int = 0
var timing_wave_index_direction : int
var loop_count: int 


var bullet_updater_2d : ProjectileUpdater2D

var bullet_count: int = 0


signal spawn_timed
signal scheduler_completed

func _exit_tree() -> void:
	disconnect_bullet_scheduler()
	pass

func _enter_tree() -> void:
	pass


func _ready() -> void:
	if active:
		activate_bullet_spawner()
		# setup_bullet_spawner()
		# if start_delay_timer:
		# 	start_delay_timer.start()

	pass

func setup_bullet_spawner() -> void:
	bullet_composer = ProjectileEngine.bullet_composer_nodes.get(bullet_composer_name)

	if !bullet_composer:
		print_debug(bullet_composer_name + " PatternComposer ID is not valid")
		return

	if !is_instance_valid(ProjectileEngine.bullet_updater_2d_nodes.get(bullet_template_2d.bullet_area_rid)):
		create_bullet_updater()

	bullet_updater_2d = ProjectileEngine.bullet_updater_2d_nodes.get(bullet_template_2d.bullet_area_rid)




func clear_bullet_spawner() -> void:
	if shoot_cooldown_timer:
		shoot_cooldown_timer.queue_free()
	if start_delay_timer:
		start_delay_timer.queue_free()
	timing_wave_index = 0
	timing_wave_index_direction = 0

func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

var composer_var : Dictionary

func spawn_pattern() -> void:
	if !active: return
	if !ProjectileEngine.projectile_environment:
		print_debug("No Projectile Environment")
		return

	pattern_packs = bullet_composer.request_pattern(global_position, composer_var)
	bullet_updater_2d.spawn_bullet_pattern(pattern_packs)

	pass


var remove_array : Array


func create_bullet_updater() -> void:
	var _bullet_updater := ProjectileUpdater2D.new()

	_bullet_updater.bullet_template_2d = bullet_template_2d

	ProjectileEngine.projectile_environment.add_child(_bullet_updater)
	bullet_area = _bullet_updater.bullet_area_rid 
	bullet_template_2d.bullet_area_rid = _bullet_updater.bullet_area_rid 
	ProjectileEngine.bullet_updater_2d_nodes.get_or_add(bullet_area, _bullet_updater)
	bullet_updater_2d = _bullet_updater

	pass


#region Scheduler

func setup_bullet_scheduler() -> void:
	if !shoot_cooldown_timer:
		setup_shoot_cooldown_timer()
	if !spawn_timed.is_connected(spawn_pattern):
		spawn_timed.connect(spawn_pattern)

	if bullet_scheduler.do_start_delay:
		if !start_delay_timer:  
			setup_start_delay_timer()
		start_delay_timer.start()
	else:
		start_next_scheduler_timing_interval()

	if !scheduler_completed.is_connected(_on_bullet_scheduler_completed):
		scheduler_completed.connect(_on_bullet_scheduler_completed)

	if bullet_scheduler.destroy_after_finish:
		scheduler_completed.connect(queue_free)

	pass

func _on_bullet_scheduler_completed() -> void:
	if bullet_scheduler.destroy_after_finish:
		queue_free()
	active = false

	pass

func disconnect_bullet_scheduler() -> void:
	if !shoot_cooldown_timer: return

	shoot_cooldown_timer.stop()
	if start_delay_timer:
		start_delay_timer.stop()
		pass
	scheduler_completed.disconnect(_on_bullet_scheduler_completed)
	spawn_timed.disconnect(spawn_pattern)
	pass


func activate_bullet_spawner() -> void:
	connect_audio()
	setup_bullet_spawner()
	setup_bullet_scheduler()

	pass

func deactive_bullet_spanwer() -> void:
	disconnect_bullet_scheduler()
	reset_scheduler_interval()
	disconnect_audio()
	pass

func play_audio() -> void:
	if !audio_stream: return
	audio_stream.playing = true
	pass

func connect_audio() -> void:
	if !audio_stream: return
	spawn_timed.connect(play_audio)
	pass

func disconnect_audio() -> void:
	if !audio_stream: return
	spawn_timed.disconnect(play_audio)
	pass

func get_next_scheduler_timing_wave() -> TimingWave:
	if bullet_scheduler.loop_amout > 0:
		if loop_count >= bullet_scheduler.loop_amout:
			scheduler_completed.emit()
			shoot_cooldown_timer.stop()
			return null
		loop_count += 1

	var _next_timing_wave : TimingWave

	match bullet_scheduler.loop_type:
		0: #LOOP_TYPE.ONE_AND_KEEP
			_next_timing_wave = bullet_scheduler.timing_wave[timing_wave_index]
			if timing_wave_index <  bullet_scheduler.timing_wave.size() - 1:
				timing_wave_index += 1

		1: #LOOP_TYPE.LOOP_FROM_START:
			_next_timing_wave = bullet_scheduler.timing_wave[timing_wave_index]

			if timing_wave_index == bullet_scheduler.timing_wave.size() - 1:
				timing_wave_index = 0
			else:
				timing_wave_index += 1
		2: #LOOP_TYPE.LOOP_FROM_END:
			_next_timing_wave = bullet_scheduler.timing_wave[timing_wave_index]
			if bullet_scheduler.timing_wave.size() == 1:
				timing_wave_index_direction = 0
			elif timing_wave_index ==  bullet_scheduler.timing_wave.size() - 1:
				timing_wave_index_direction = -1
			elif timing_wave_index == 0:
				timing_wave_index_direction = 1
			timing_wave_index += timing_wave_index_direction

		3: #LOOP_TYPE.RANDOM:
			_next_timing_wave = bullet_scheduler.timing_wave.pick_random()

		4: #LOOP_TYPE.RANDOM_WEIGHTED:
			var _rand: = RandomNumberGenerator.new()
			var weight_array := []
			for wave : TimingWave in bullet_scheduler.timing_wave:
				weight_array.append(wave.weight)
			_next_timing_wave = bullet_scheduler.timing_wave[_rand.rand_weighted(weight_array)]


	return _next_timing_wave


var timing_interval : Array[float] = []

func start_next_scheduler_timing_interval() -> void:
	if timing_interval.size() == 0:
		var _timing_wave := get_next_scheduler_timing_wave()
		if ! _timing_wave: return
		timing_interval.append_array(_timing_wave.timing_wave)

	spawn_timed.emit()
	shoot_cooldown_timer.start(timing_interval.pop_front())

func reset_scheduler_interval() -> void:
	timing_interval.clear()
	timing_wave_index = 0
	loop_count = 0
	pass


func stop_scheduler() -> void:
	shoot_cooldown_timer.stop()
	timing_interval.clear()
	pass

func setup_shoot_cooldown_timer() -> void:
	if shoot_cooldown_timer: return
	shoot_cooldown_timer = Timer.new()
	shoot_cooldown_timer.autostart = false
	shoot_cooldown_timer.one_shot = true
	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timer_timeout)
	add_child(shoot_cooldown_timer)

func _on_shoot_cooldown_timer_timeout() -> void:
	start_next_scheduler_timing_interval()
	pass


func setup_start_delay_timer() -> void:
	if start_delay_timer: return

	start_delay_timer = Timer.new()
	start_delay_timer.autostart = false
	start_delay_timer.one_shot = true

	if bullet_scheduler.is_rand_start_delay:
		bullet_scheduler.start_delay_time = randf_range(bullet_scheduler.start_delay_min, bullet_scheduler.start_delay_max)
	start_delay_timer.wait_time = bullet_scheduler.start_delay_time

	start_delay_timer.timeout.connect(_on_start_delay_timer_timeout)

	add_child(start_delay_timer)
	
func _on_start_delay_timer_timeout() -> void:

	start_next_scheduler_timing_interval()
	pass

#endregion
