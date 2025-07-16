extends Node



signal projectile_instance_triggered(trigger_name: String, projectile_instance)
signal projectile_node_triggered(trigger_name: String, projectile_node: Projectile2D)

signal projectile_instance_pierced(projectile_node: ProjectileInstance2D, pierced_node: Node2D)

signal projectile_instance_body_shape_entered(
	projectile_instance, 
	body_rid : RID, body: Node, body_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int
	)

signal projectile_instance_body_shape_exited(
	projectile_instance, 
	body_rid : RID, body: Node, body_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int
	)

signal projectile_instance_body_entered(
	projectile_instance, body: Node,
	)
signal projectile_instance_body_exited(
	projectile_instance, body: Node,
	)


signal projectile_instance_area_shape_entered(
	projectile_instance, 
	area_rid : RID, area: Node, area_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int
	)

signal projectile_instance_area_shape_exited(
	projectile_instance, 
	area_rid : RID, area: Node, area_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int
	)

signal projectile_instance_area_entered(
	projectile_instance, area: Node,
	)

signal projectile_instance_area_exited(
	projectile_instance, area: Node,
	)


enum BehaviorContext{
	PHYSICS_DELTA,
	GLOBAL_POSITION,
	PROJECTILE_OWNER,
	BEHAVIOR_OWNER,
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
var projectile_node_manager_2d_nodes : Dictionary[StringName, ProjectileNodeManager2D]


var projectile_composer_nodes : Dictionary[String, PatternComposer2D]

var projectile_boundary_2d : ProjectileBoundary2D


func _ready() -> void:
	# projectile_instance_triggered.connect(_test_projectile_instance_triggered)
	projectile_node_triggered.connect(_test_projectile_node_triggered)

	# projectile_instance_body_shape_entered.connect(_test_projectile_instance_body_shape_entered)
	# projectile_instance_body_shape_exited.connect(_test_projectile_instance_body_shape_exited)
	# projectile_instance_body_entered.connect(_test_projectile_instance_body_entered)
	# projectile_instance_body_exited.connect(_test_projectile_instance_body_exited)

	# projectile_instance_area_shape_entered.connect(_test_projectile_instance_area_shape_entered)
	# projectile_instance_area_shape_exited.connect(_test_projectile_instance_area_shape_exited)
	# projectile_instance_area_entered.connect(_test_projectile_instance_area_entered)
	# projectile_instance_area_exited.connect(_test_projectile_instance_area_exited)
	pass

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

func _test_projectile_instance_body_shape_entered(
	projectile_instance, 
	body_rid : RID, body: Node, body_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int) -> void:
	
	print("{0} - {1} - {2} - {3} - {4} - {5}".format([
		projectile_instance, 
		body_rid, body, body_shape_idx,
		projectile_rid, projectile_idx
		]))
	pass

func _test_projectile_instance_body_shape_exited(
	projectile_instance, 
	body_rid : RID, body: Node, body_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int) -> void:
	
	print("{0} - {1} - {2} - {3} - {4} - {5}".format([
		projectile_instance, 
		body_rid, body, body_shape_idx,
		projectile_rid, projectile_idx
		]))
	pass

func _test_projectile_instance_body_entered(
	projectile_instance, body) -> void:
	
	print("{0} - {1}".format([projectile_instance, body]))
	pass

func _test_projectile_instance_body_exited(
	projectile_instance, body) -> void:
	
	print("{0} - {1}".format([projectile_instance, body]))
	pass


func _test_projectile_instance_area_shape_entered(
	projectile_instance, 
	area_rid : RID, area: Node, area_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int) -> void:
	
	print("{0} - {1} - {2} - {3} - {4} - {5}".format([
		projectile_instance, 
		area_rid, area, area_shape_idx,
		projectile_rid, projectile_idx
		]))
	pass

func _test_projectile_instance_area_shape_exited(
	projectile_instance, 
	area_rid : RID, area: Node, area_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int) -> void:
	
	print("{0} - {1} - {2} - {3} - {4} - {5}".format([
		projectile_instance, 
		area_rid, area, area_shape_idx,
		projectile_rid, projectile_idx
		]))
	pass

func _test_projectile_instance_area_entered(
	projectile_instance, area) -> void:
	
	print("{0} - {1}".format([projectile_instance, area]))
	pass

func _test_projectile_instance_area_exited(
	projectile_instance, area) -> void:
	
	print("{0} - {1}".format([projectile_instance, area]))
	pass
