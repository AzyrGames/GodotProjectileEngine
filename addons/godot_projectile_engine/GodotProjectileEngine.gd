extends Node



signal projectile_instance_triggered(trigger_name: String, projectile_instance)
signal projectile_node_triggered(trigger_name: String, projectile_node: Projectile2D)

enum BehaviorContext{
	PHYSICS_DELTA,
	LIFE_TIME_TICK,
	LIFE_TIME_SECOND,
	LIFE_DISTANCE,
	BASE_SPEED,
	DIRECTION_COMPONENT,
	DIRECTION,
	BASE_DIRECTION,
	BASE_SCALE,
	ROTATION,
	RANDOM_NUMBER_GENERATOR,
	ARRAY_VARIABLE,
	
}


var active_projectile_count : int
var projectile_environment : ProjectileEnvironment2D

var projectile_updater_2d_nodes : Dictionary[RID, ProjectileUpdater2D]
var projectile_updater_simple_2d_nodes : Dictionary[RID, ProjectileUpdaterSimple2D]
var projectile_updater_advanced_2d_nodes : Dictionary[RID, ProjectileUpdaterAdvanced2D]



var projectile_composer_nodes : Dictionary[String, PatternComposer2D]

var projectile_boundary_2d : ProjectileBoundary2D


func _ready() -> void:
	projectile_instance_triggered.connect(_test_projectile_instance_triggered)
	projectile_node_triggered.connect(_test_projectile_node_triggered)

func get_projectile_count() -> int:
	active_projectile_count = 0

	for projectile_updater in projectile_updater_2d_nodes.values():
		if projectile_updater:
			active_projectile_count += projectile_updater.get_active_projectile_count()
		pass
	
	return active_projectile_count
	pass


func clear() -> void:
	projectile_updater_2d_nodes.clear()
	projectile_composer_nodes.clear()
	pass

func clear_projectile() -> void:
	for _projectile_udpater_node in projectile_updater_2d_nodes.values():
		_projectile_udpater_node.clear_projectile()
	pass

func _test_projectile_instance_triggered(trigger_name: String, projectile_instance) -> void:
	print("Projectile instance triggered: ", trigger_name , " - ", projectile_instance)
	pass

func _test_projectile_node_triggered(trigger_name: String, projectile_node: Projectile2D) -> void:
	print("Projectile node2d triggered: ", trigger_name , " - ", projectile_node)

	pass