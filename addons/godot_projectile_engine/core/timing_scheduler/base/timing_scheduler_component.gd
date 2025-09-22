extends Node
class_name TimingSchedulerComponent

signal tsc_timed
signal tsc_completed

enum UpdateMode {
	IDLE, ## Update the timing every process (rendered) frame
	PHYSICS, ## Update the timing every physics process frame
	INHERIT, ## Inherit the [code]update_mode[/code] from the parent TimingScheduler node.
}

enum TimingMode {
	INSTANT, ## Timed instantly when process
	RELEASE, ## Timed after timing finished
	NO, ## No timed emited.
}

@export var active : bool = true:
	set(value):
		active = value
		if !value:
			clear_timing_timer()
@export var timing_mode: TimingMode = TimingMode.INSTANT
@export var update_mode: UpdateMode = UpdateMode.INHERIT


var timing_timer: Timer

var request_stop : bool = false

func start_next_timing_value() -> void:
	pass

func get_next_timing_value() -> float:
	return 0.0

func start_tsc() -> void:
	setup_timing_timer()
	start_next_timing_value()
	pass


func stop_tsc() -> void:
	clear_timing_timer()
	pass

func setup_timing_timer() -> void:
	timing_timer = Timer.new()
	timing_timer.autostart = false
	timing_timer.one_shot = true
	timing_timer.timeout.connect(on_timing_timer_timeout)

	match update_mode:
		UpdateMode.IDLE:
			timing_timer.process_callback = Timer.TIMER_PROCESS_IDLE
			pass
		UpdateMode.PHYSICS:
			timing_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
			pass
		UpdateMode.INHERIT:
			if owner is TimingScheduler:
				match owner.update_mode:
					UpdateMode.IDLE:
						timing_timer.process_callback = Timer.TIMER_PROCESS_IDLE
						pass
					UpdateMode.PHYSICS:
						timing_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
						pass
			pass
	
	add_child(timing_timer)
	pass


func clear_timing_timer() -> void:
	if !timing_timer: return
	timing_timer.stop()
	timing_timer.queue_free()
	pass


func on_timing_timer_timeout() -> void:
	pass