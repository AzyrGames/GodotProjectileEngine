# @tool
extends Node2D
class_name BulletSpawner2D

@export var active : bool = true


var bullet_area : RID

@export var bullet_template_2d : BulletTemplate2D

@export var bullet_composer_name : String
var bullet_composer : BulletComposer2D

@export var bullet_scheduler : BulletScheduler

var pattern_packs: Array

var start_delay_timer : Timer
var shoot_cooldown_timer: Timer

var timing_wave_index : int = 0
var timing_wave_index_direction : int
var loop_count: int 


var bullet_updater_2d : BulletUpdater2D

var bullet_count: int = 0


signal spawn_timed

func _exit_tree() -> void:
	pass

func _enter_tree() -> void:
	pass


func _ready() -> void:
	bullet_composer = BulletHell.bullet_composer_nodes.get(bullet_composer_name)
	if !bullet_composer:
		print_debug(bullet_composer_name + " BulletComposer ID is not valid")
		return
	setup_bullet_scheduler()
	setup_shoot_cooldown_timer()
	if bullet_scheduler.do_start_delay:
		setup_start_delay_timer()
	else:
		start_next_interval()




func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

var composer_var : Dictionary

func spawn_bullet() -> void:
	if !active: return
	if !BulletHell.bullet_environment:
		print_debug("No Projectile Environment")
		return

	pattern_packs = bullet_composer.create_pattern(global_position, composer_var)

	if !bullet_updater_2d:
		create_bullet_updater()

	bullet_updater_2d.spawn_bullet(pattern_packs)

	pass


var remove_array : Array


func create_bullet_updater() -> void:
	var _bullet_updater := BulletUpdater2D.new()

	_bullet_updater.bullet_template_2d = bullet_template_2d

	BulletHell.bullet_environment.add_child(_bullet_updater)
	bullet_area = _bullet_updater.bullet_area_rid 

	BulletHell.bullet_updater_2d_nodes.get_or_add(bullet_area, _bullet_updater)
	bullet_updater_2d = _bullet_updater

	pass


func setup_bullet_scheduler() -> void:
	spawn_timed.connect(spawn_bullet)
	pass

func disconnect_bullet_scheduler() -> void:
	pass



func get_next_timing_wave() -> BulletTimingWave:

	if bullet_scheduler.loop_amout > 0:
		if loop_count >= bullet_scheduler.loop_amout:
			bullet_scheduler.scheduler_completed.emit()
			shoot_cooldown_timer.stop()
			return null
		loop_count += 1

	var _next_timing_wave : BulletTimingWave

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
			for wave : BulletTimingWave in bullet_scheduler.timing_wave:
				weight_array.append(wave.weight)
			_next_timing_wave = bullet_scheduler.timing_wave[_rand.rand_weighted(weight_array)]


	return _next_timing_wave


var timing_interval : Array[float] = []

func start_next_interval() -> void:
	if timing_interval.size() == 0:
		var _timing_wave := get_next_timing_wave()
		if ! _timing_wave: return
		timing_interval.append_array(_timing_wave.timing_wave)

	spawn_timed.emit()
	shoot_cooldown_timer.start(timing_interval.pop_front())


func stop_scheduler() -> void:
	shoot_cooldown_timer.stop()
	timing_interval.clear()
	pass

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
	if bullet_scheduler.is_rand_start_delay:
		bullet_scheduler.start_delay_time = randf_range(bullet_scheduler.start_delay_min, bullet_scheduler.start_delay_max)

	start_delay_timer.wait_time = bullet_scheduler.start_delay_time
	start_delay_timer.timeout.connect(_on_start_delay_timer_timeout)
	add_child(start_delay_timer)
	
func _on_start_delay_timer_timeout() -> void:

	start_next_interval()
	pass
