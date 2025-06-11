extends Node2D

@export var timing_scheduler : TimingScheduler


func _enter_tree() -> void:
	timing_scheduler.scheduler_timed.connect(_on_scheduler_timed)


func _on_scheduler_timed() -> void:
	print("hello")
	pass
