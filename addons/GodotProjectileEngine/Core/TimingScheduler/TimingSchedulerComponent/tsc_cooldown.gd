extends TimingSchedulerComponent
class_name TSCCooldown


@export var cooldown_duration : float = 1.0


func start_next_timing_value() -> void:
	tsc_timed.emit()
	var _timing_value := get_next_timing_value()
	if _timing_value <= 0.0:
		tsc_completed.emit()
		return
	timing_timer.start(_timing_value)
	pass


func get_next_timing_value() -> float:
	return cooldown_duration


func on_timing_timer_timeout() -> void:
	tsc_completed.emit()
	pass