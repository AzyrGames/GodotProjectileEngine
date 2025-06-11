extends TimingSchedulerComponent
class_name TSCCooldown

## Cooldown timing scheduler component that waits for a fixed duration before completing

## Duration of the cooldown in seconds
@export var cooldown_duration : float = 1.0

## Starts the cooldown timer with the next timing value
func start_next_timing_value() -> void:
	# Emit timed signal immediately since cooldown starts right away
	tsc_timed.emit()
	
	if cooldown_duration <= 0.0:
		# If duration is 0 or negative, complete immediately
		tsc_completed.emit()
		return
	
	# Start the timer with the cooldown duration
	timing_timer.start(cooldown_duration)

## Called when the cooldown timer completes
func on_timing_timer_timeout() -> void:
	tsc_completed.emit()
