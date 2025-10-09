@icon("uid://b8xxmwe5p03cx")
extends TimingSchedulerComponent
class_name TSCRepeater


## Duration to repeat in seconds
@export var duration: float = 1.0
@export var repeat_count: int = 1
var current_count: int = 0 ## Current repetition count

@export_group("Random")
@export var random_duration: Vector3 = Vector3.ZERO
@export var random_repeat_count: Vector3i = Vector3i.ZERO


func _ready() -> void:
	if random_repeat_count != Vector3i.ZERO:
		repeat_count = ProjectileEngine.get_random_int_value(random_repeat_count)

## Override stop_tsc to reset counter and call parent implementation
func stop_tsc() -> void:
	super.stop_tsc()
	current_count = 0

## Starts the next timing value (first repetition)
func start_next_timing_value() -> void:
	tsc_timed.emit()
	
	# If repeat_count is 0 complete immediately
	if repeat_count == 0:
		tsc_completed.emit()
		return
	
	# If duration is 0 or negative, complete immediately
	if duration <= 0.0:
		tsc_completed.emit()
		return
	
	# Reset counter and start first repetition
	current_count = 0
	start_timing_timer()

## Handles timer timeout events
func on_timing_timer_timeout() -> void:
	if repeat_count < 0:
		# For Soft Stop
		if request_stop:
			tsc_completed.emit()
			request_stop = false
		else:
			# Infinite mode - always restart timer
			tsc_timed.emit()
			start_timing_timer()
	else:
		# Finite mode - increment count and check if complete
		current_count += 1
		if current_count < repeat_count:
			tsc_timed.emit()
			start_timing_timer()
		else:
			tsc_completed.emit()

func start_timing_timer() -> void:
	if random_duration != Vector3.ZERO:
		duration = ProjectileEngine.get_random_float_value(random_duration)
	timing_timer.start(duration)
	pass
