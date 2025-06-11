extends Resource
class_name TimingSet

## A collection of timing intervals with playback modes

## Playback modes for the timing set
enum PlaybackMode {
	SEQUENTIAL,		## Play intervals in order
	RANDOM, 		## Play intervals in random order
}

@export var entries: Array[float]
@export var playback_mode: PlaybackMode = PlaybackMode.SEQUENTIAL
@export var repeat_count: int = 1
