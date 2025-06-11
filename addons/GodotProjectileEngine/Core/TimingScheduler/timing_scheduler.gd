extends Node
class_name TimingScheduler

## Hello
signal scheduler_timed
signal timing_timed
signal scheduler_completed

enum UpdateMode {
	IDLE, ## Update the timing every process (rendered) frame
	PHYSICS, ## Update the timing every physics process frame
}

enum UpdateMethod {
	TIMER, ## Regular Godot Timer
	# TICKS, ## Manual Frame Tick
}

const _DEFAULT_SEQUENCE_INDEX : int = -1


@export var active : bool = false:
	set(value):
		active = value
		if value:
			_start_timing_scheduler()
		else:
			_stop_timing_scheduler()

## Select the timing update mode for Timing Scheduler
@export var update_mode: UpdateMode = UpdateMode.PHYSICS

## Select the timing update method for Timing Scheduler
@export var update_method: UpdateMethod = UpdateMethod.TIMER

var tsc_sequence : Array[TimingSchedulerComponent]


var tsc_sequence_index : int = _DEFAULT_SEQUENCE_INDEX

var current_tsc : TimingSchedulerComponent



func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	pass


func _ready() -> void:
	if active:
		_build_tsc_sequence()
		_start_timing_scheduler()
	pass


func _start_timing_scheduler() -> void:
	if tsc_sequence.size() <= 0: 
		return
	if !start_next_tsc():
		scheduler_completed.emit()
		active = false
	pass

func _stop_timing_scheduler() -> void:
	current_tsc = null
	tsc_sequence_index = _DEFAULT_SEQUENCE_INDEX
	pass

func _build_tsc_sequence() -> void:
	for _node in get_children():
		if _node is not TimingSchedulerComponent: continue
		tsc_sequence.append(_node)
	pass

func start_next_tsc() -> bool:
	var _next_tsc := _get_next_tsc()
	if !_next_tsc: 
		return false
	if current_tsc:
		current_tsc.stop_tsc()
	current_tsc = _next_tsc
	current_tsc.tsc_timed.connect(_on_tsc_timed)
	current_tsc.tsc_completed.connect(_on_tsc_completed)

	current_tsc.start_tsc()
	return true
	pass



func _get_next_tsc() -> TimingSchedulerComponent:
	tsc_sequence_index += 1
	# Base case: if index is beyond sequence length, return null
	if tsc_sequence_index > tsc_sequence.size() - 1:
		return null

	var _current_component = tsc_sequence[tsc_sequence_index]
	
	# If component is active, return it
	if _current_component.active:
		return _current_component
	
	# Recursive case: skip inactive components
	return _get_next_tsc()

func _on_tsc_timed() -> void:
	scheduler_timed.emit()
	pass

func _on_tsc_completed() -> void:
	start_next_tsc()
	pass
