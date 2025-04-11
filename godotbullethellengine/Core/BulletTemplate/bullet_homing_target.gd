extends Marker2D
class_name BulletHomingTarget2D

@export var homing_id : String

# Called when the node enters the scene tree for the first time.

func _enter_tree() -> void:
	if homing_id == null: return
	var _homing_targets : Variant = BulletHell.bullet_homing_targets.get_or_add(homing_id, [self])
	if self not in _homing_targets:
		_homing_targets.append(self)
	print(_homing_targets)
	pass


func _exit_tree() -> void:
	if homing_id == null: return
	BulletHell.bullet_homing_targets[homing_id].erase(self)
	pass # Replace with function body.


func _ready() -> void:
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
