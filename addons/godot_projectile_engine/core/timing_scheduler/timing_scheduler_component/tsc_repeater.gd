extends TimingSchedulerComponent
class_name TSCRepeater

## Repeats a duration multiple times
## - repeat_count = 0: Complete immediately
## - repeat_count < 0: Infinite repetitions
## - repeat_count > 0: Finite repetitions

@export var duration: float = 1.0  ## Duration to repeat in seconds
@export var repeat_count: int = -1  ## Repetition count (0=immediate, <0=infinite, >0=finite)

var current_count: int = 0  ## Current repetition count

## Override stop_tsc to reset counter and call parent implementation
func stop_tsc() -> void:
	super.stop_tsc()
	current_count = 0

## Starts the next timing value (first repetition)
func start_next_timing_value() -> void:
	if repeat_count == 0:
		# Immediate completion
		tsc_completed.emit()
		return
		
	# Reset counter and start first repetition
	current_count = 0
	tsc_timed.emit()
	timing_timer.start(duration)

## Handles timer timeout events
func on_timing_timer_timeout() -> void:
	if repeat_count < 0:
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
