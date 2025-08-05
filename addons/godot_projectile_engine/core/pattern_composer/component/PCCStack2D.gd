## Projectile Pattern Component
@icon("uid://hhcp20t33vtb")
extends PatternComposerComponent
class_name PCCStack2D

@export var stack_amount: int = 3
@export var stack_distance: float = 15.0

@export_group("Random")
@export var stack_amount_random: Vector3i
@export var stack_distance_random: Vector3


var _offset_distance: Vector2


func process_pattern(
	_pattern_composer_pack: Array[PatternComposerData],
	_pattern_composer_context: PatternComposerContext
	) -> Array:
	if stack_amount_random != Vector3i.ZERO:
		stack_amount = ProjectileEngine.get_random_int_value(stack_amount_random)
	if stack_distance_random != Vector3.ZERO:
		stack_distance = ProjectileEngine.get_random_float_value(stack_distance_random)

	_new_pattern_composer_pack.clear()
	for _pattern_composer_data: PatternComposerData in _pattern_composer_pack:
		for i in stack_amount:
			_offset_distance = i * stack_distance * _pattern_composer_data.direction.rotated(
				_pattern_composer_data.direction_rotation
				)

			_new_pattern_composer_data = _pattern_composer_data.duplicate()
			_new_pattern_composer_data.position = _pattern_composer_data.position + _offset_distance
			_new_pattern_composer_pack.append(_new_pattern_composer_data)
	return _new_pattern_composer_pack
