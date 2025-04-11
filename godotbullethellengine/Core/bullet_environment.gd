extends Node2D
class_name BulletEnvironment2D

# var bullet_instance_array : Array[BulletInstance2D]

var bullet_updater_node : Dictionary[RID, BulletUpdater2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BulletHell.bullet_environment = self
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	pass


func spawner_destroyed(area_rid: RID) -> void:
	if !bullet_updater_node.get(area_rid): return
	bullet_updater_node.get(area_rid).spawner_destroyed = true
	pass


func bullet_collided(bullet_area_rid: RID, shape_idx: int) -> void:
	if bullet_updater_node.has(bullet_area_rid):
		bullet_updater_node[bullet_area_rid].process_bullet_collided(shape_idx)

func get_bullet_damage(bullet_area_rid: RID) -> int:
	if bullet_updater_node.has(bullet_area_rid):
		return bullet_updater_node[bullet_area_rid].bullet_damage
	return 0
