@icon("uid://dxl14aphe1elg")
extends Resource
class_name TimingSet

## Resource containing timing intervals and playback parameters for sequenced or randomized execution.

## Enum defining playback modes for the timing set
enum PlaybackMode {
	SEQUENTIAL,		## Execute intervals in defined order
	RANDOM			## Execute intervals in randomized order
}

## List of interval durations in seconds
@export var entries: Array[float]

## Select playback mode for the timing set
@export var playback_mode: PlaybackMode = PlaybackMode.SEQUENTIAL

## Number of times to repeat the timing sequence
@export var repeat_count: int = 1
