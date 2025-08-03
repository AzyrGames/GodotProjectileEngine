@icon("uid://dxl14aphe1elg")
extends TimingSchedulerComponent
class_name TSCTimingSet

## Manages complex timing patterns using a TimingSet resource.
## Handles sequential and random playback modes with repeat logic.


## TimingSet Resource containing timing intervals and playback parameters for sequenced or randomized execution.
@export var timing_set: TimingSet  

var _timing_set_index: int = -1  # Current index in timing entries
var _current_repeat_count: int = 0  # Number of completed cycles
var _current_interval: float = 0.0  # Current interval duration
var _shuffled_entries: Array[float] = []  # Shuffled entries for RANDOM mode


func _validate_property(property: Dictionary) -> void:
	# Ensure proper resource type hinting for timing_set
	if property.name == "timing_set" and property.type == TYPE_OBJECT:
		property.hint = PROPERTY_HINT_RESOURCE_TYPE
		property.hint_string = "TimingSet"


func _ready() -> void:
	# Validate required resource and disable component if missing
	if not timing_set:
		push_warning("No TimingSet resource assigned to TSCTimingSet")
		active = false


## Resets internal state and stops the timer
func stop_tsc() -> void:
	super.stop_tsc()
	_timing_set_index = -1
	_current_repeat_count = 0
	_current_interval = 0.0
	_shuffled_entries = []


## Advances to the next timing interval based on current mode
func start_next_timing_value() -> void:
	# Exit early if invalid state or completion conditions met
	if not timing_set or timing_set.entries.is_empty() or timing_set.repeat_count == 0:
		tsc_completed.emit()
		stop_tsc()
		return

	# Check repeat condition 
	if timing_set.repeat_count > 0 and _current_repeat_count >= timing_set.repeat_count:
		tsc_completed.emit()
		stop_tsc()
		return

	## Complete when having stop request
	if timing_set.repeat_count < 0:
		if request_stop:
			tsc_completed.emit()
			request_stop = false
			stop_tsc()
			return

	_current_interval = get_next_timing_value()

	# Handle immediate next interval if current is zero/negative
	if _current_interval <= 0.0:
		start_next_timing_value()
		return
	
	# Emit timed signal and start interval timer
	tsc_timed.emit()
	timing_timer.start(_current_interval)


## Triggers next interval when timer completes
func on_timing_timer_timeout() -> void:
	start_next_timing_value()


## Retrieves next interval value based on playback mode
func get_next_timing_value() -> float:
	if not timing_set or timing_set.entries.is_empty():
		return 0.0

	var _interval_value: float = 0.0

	match timing_set.playback_mode:
		TimingSet.PlaybackMode.SEQUENTIAL:
			# Increment index and loop at end of sequence
			_timing_set_index += 1
			_interval_value = timing_set.entries[_timing_set_index]
			if _timing_set_index >= timing_set.entries.size() - 1:
				_current_repeat_count += 1
				_timing_set_index = -1  # Reset index for next cycle

		TimingSet.PlaybackMode.RANDOM:
			# Initialize shuffled list at start of cycle
			if _shuffled_entries.is_empty():
				_shuffled_entries = timing_set.entries.duplicate()
				_shuffled_entries.shuffle()
			_interval_value = _shuffled_entries.pop_front()
			
			# Increment repeat count when shuffled list is exhausted
			if _shuffled_entries.is_empty():
				_current_repeat_count += 1

	return _interval_value
