@icon("uid://b8xxmwe5p03cx")
extends TimingSchedulerComponent
class_name TSCRepeater

## Repeats a duration multiple times
## - repeat_count = 0: Complete immediately
## - repeat_count < 0: Infinite repetitions
## - repeat_count > 0: Finite repetitions

## Duration to repeat in seconds
@export var duration: float = 1.0  
## Repetition count (0=immediate, <0 infinite, >0 finite)
@export var repeat_count: int = -1  

var current_count: int = 0  ## Current repetition count

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
	timing_timer.start(duration)

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
			timing_timer.start(duration)
	else:
		# Finite mode - increment count and check if complete
		current_count += 1
		if current_count < repeat_count:
			tsc_timed.emit()
			timing_timer.start(duration)
		else:
			tsc_completed.emit()
		
