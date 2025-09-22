@icon("uid://ctn5777goa2uq")
extends Node
class_name TimingScheduler

## Emitted when the scheduler times an event
signal scheduler_timed

## Emitted when the scheduler completes all timing components
signal scheduler_completed

## Timing update modes
enum UpdateMode {
	IDLE, ## Update the timing every process (rendered) frame
	PHYSICS, ## Update the timing every physics process frame
}

## Timing update methods
enum UpdateMethod {
	TIMER, ## Regular Godot Timer
	# TICKS, ## Manual Frame Tick (commented out for future use)
}

## Scheduler stop methods
enum StopMethod {
	HARD_STOP, ## Force stop current timing scheduler component
	SOFT_STOP, ## Finish current timing scheduler component before stopping
}

const _DEFAULT_SEQUENCE_INDEX: int = -1


@export var active: bool = false
## If true, scheduler starts automatically when added to scene tree
@export var autostart: bool = false

## Timing update mode (IDLE or PHYSICS)
@export var update_mode: UpdateMode = UpdateMode.PHYSICS

## Timing update method (currently only TIMER supported)
@export var update_method: UpdateMethod = UpdateMethod.TIMER

## Stop method (HARD_STOP or SOFT_STOP)
@export var stop_method: StopMethod = StopMethod.SOFT_STOP

## Array of TimingSchedulerComponent nodes in sequence
var tsc_sequence: Array[TimingSchedulerComponent]

## Current index in the timing sequence
var tsc_sequence_index: int = _DEFAULT_SEQUENCE_INDEX

## Currently active timing component
var current_tsc: TimingSchedulerComponent

## Pause state of the scheduler
var paused: bool = true

var _is_queue_soft_stop: bool = false

var _is_just_started: bool = false


func _ready() -> void:
	if autostart:
		call_deferred("start_scheduler")

func _physics_process(delta: float) -> void:
	if active:
		if paused:
			start_scheduler()
			start_timing_scheduler()
	else:
		if !paused:
			stop_scheduler()
	pass


## Starts the timing scheduler
func start_scheduler() -> void:
	if !paused:
		return
	_build_tsc_sequence()


## Stops the timing scheduler using configured stop method
func stop_scheduler() -> void:
	match stop_method:
		StopMethod.HARD_STOP:
			hard_stop_timing_scheduler()
		StopMethod.SOFT_STOP:
			soft_stop_timing_scheduler()

func start_timing_scheduler() -> void:
	if tsc_sequence.is_empty():
		return
	if start_next_tsc():
		paused = false
	else:
		paused = true
		scheduler_completed.emit()


func force_stop_timing_scheduler() -> void:
	if current_tsc:
		current_tsc.stop_tsc()
	_disconnect_tsc_signals(current_tsc)
	current_tsc = null
	paused = true
	tsc_sequence_index = _DEFAULT_SEQUENCE_INDEX
	pass

func hard_stop_timing_scheduler() -> void:
	if not current_tsc:
		return
	current_tsc.stop_tsc()
	_disconnect_tsc_signals(current_tsc)
	current_tsc = null
	paused = true
	tsc_sequence_index = _DEFAULT_SEQUENCE_INDEX
	scheduler_completed.emit()


func soft_stop_timing_scheduler() -> void:
	if not current_tsc:
		return
	_disconnect_tsc_signals(current_tsc)
	current_tsc.request_stop = true
	if !current_tsc.tsc_completed.is_connected(_on_soft_stop_tsc_completed):
		current_tsc.tsc_completed.connect(_on_soft_stop_tsc_completed)


## Builds the sequence of TimingSchedulerComponent nodes from children
func _build_tsc_sequence() -> void:
	tsc_sequence.clear()
	if get_child_count() <= 0:
		push_warning(self, " is empty")
		return
	for node in get_children():
		if node is TimingSchedulerComponent:
			tsc_sequence.append(node)


## Starts the next timing scheduler component in sequence
func start_next_tsc() -> bool:
	var next_tsc := _get_next_tsc()
	if not next_tsc:
		return false
	if current_tsc:
		current_tsc.stop_tsc()
		_disconnect_tsc_signals(current_tsc)
	current_tsc = next_tsc
	_connect_tsc_signals(current_tsc)
	current_tsc.start_tsc()
	return true


## Gets the next active timing scheduler component in sequence
func _get_next_tsc() -> TimingSchedulerComponent:
	tsc_sequence_index += 1
	
	# Base case: if index is beyond sequence length, return null
	if tsc_sequence_index >= tsc_sequence.size():
		return null

	# Iterative approach to find next active component
	while tsc_sequence_index < tsc_sequence.size():
		var component = tsc_sequence[tsc_sequence_index]
		if component.active:
			return component
		tsc_sequence_index += 1
		
	return null


## Handles timing events from current component
func _on_tsc_timed() -> void:
	scheduler_timed.emit()


## Handles completion events from current component
func _on_tsc_completed() -> void:
	if !start_next_tsc():
		_disconnect_tsc_signals(current_tsc)
		current_tsc = null
		paused = true
		active = false
		tsc_sequence_index = _DEFAULT_SEQUENCE_INDEX
		scheduler_completed.emit()


## Handles completion during soft stop
func _on_soft_stop_tsc_completed() -> void:
	current_tsc.stop_tsc()
	paused = true
	current_tsc.tsc_completed.disconnect(_on_soft_stop_tsc_completed)
	current_tsc = null
	tsc_sequence_index = _DEFAULT_SEQUENCE_INDEX
	scheduler_completed.emit()


func _connect_tsc_signals(tsc: TimingSchedulerComponent) -> void:
	if !tsc: return
	if !tsc.is_connected("tsc_timed", _on_tsc_timed):
		tsc.tsc_timed.connect(_on_tsc_timed)
	if !tsc.is_connected("tsc_completed", _on_tsc_completed):
		tsc.tsc_completed.connect(_on_tsc_completed)
	pass

## Disconnects signals from a timing component
func _disconnect_tsc_signals(tsc: TimingSchedulerComponent) -> void:
	if !tsc: return
	if tsc.is_connected("tsc_timed", _on_tsc_timed):
		tsc.tsc_timed.disconnect(_on_tsc_timed)
	if tsc.is_connected("tsc_completed", _on_tsc_completed):
		tsc.tsc_completed.disconnect(_on_tsc_completed)
