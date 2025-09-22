@icon("uid://buxedtgvr7tg")
extends TimingSchedulerComponent
class_name TSCCooldown

## Cooldown timing scheduler component that waits for a fixed duration before completing

## Duration of the cooldown in seconds
@export var cooldown_duration : float = 1.0

## Starts the cooldown timer with the next timing value
func start_next_timing_value() -> void:
	if timing_mode == TimingMode.INSTANT:
		tsc_timed.emit()

	# If duration is 0 or negative, complete immediately
	if cooldown_duration <= 0.0:
		tsc_completed.emit()
		return
	# Start the timer with the cooldown duration
	timing_timer.start(cooldown_duration)


## Called when the cooldown timer completes
func on_timing_timer_timeout() -> void:
	if timing_mode == TimingMode.RELEASE:
		tsc_timed.emit()
	tsc_completed.emit()
