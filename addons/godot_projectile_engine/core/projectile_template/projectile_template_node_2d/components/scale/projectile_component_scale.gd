extends ProjectileComponent
class_name ProjectileComponentScale


func get_component_name() -> StringName:
	return "projectile_component_scale"

@export_custom(PROPERTY_HINT_LINK, "suffix:") var scale: Vector2 = Vector2.ONE

@export var component_behaviors : Array[ProjectileBehaviorScale] = []

var base_scale : Vector2

var _component_behavior_convert : Array[ProjectileBehavior]


func _ready() -> void:
	base_scale = scale

func _physics_process(delta: float) -> void:
	if !active:
		return

	# if !component_behaviors:
	# 	return

	# # Convert behaviors to base type for processing
	# _component_behavior_convert.assign(component_behaviors)

	# update_behavior_context(_component_behavior_convert)
	process_projectile_behavior(_component_behavior_convert, owner.behavior_context)


func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue

		scale = _behavior.process_behavior(scale, _context)

func get_scale() -> Vector2:
	return scale
	pass
