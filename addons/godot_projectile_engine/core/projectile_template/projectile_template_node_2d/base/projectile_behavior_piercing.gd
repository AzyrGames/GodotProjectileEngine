extends ProjectileBehavior
class_name ProjectileBehaviorPiercing

## Base class for all projectile piercing behaviors in the projectile engine.
##
## Provides core functionality and interface that all piercing behavior implementations
## must follow. Piercing behaviors determine how projectiles interact with targets
## they can pierce through.

## Whether to emit a signal when piercing occurs
@export var emit_piercing_signal: bool = true

## Signal emitted when projectile pierces a target
signal target_pierced(projectile: Node, target: Node, piercing_count: int)

## Signal emitted when max piercing count is reached
signal max_piercing_reached(projectile: Node, total_pierced: int)

## Processes the piercing behavior and returns whether piercing should occur
## Returns bool: true if projectile should pierce, false if it should be stopped/destroyed
func process_behavior(_value, _context: Dictionary) -> bool:
	return true

## Called when the projectile pierces a target
## Override this to add custom piercing effects
func on_pierce(_projectile: Node, _target: Node, _context: Dictionary) -> void:
	pass

## Called when max piercing count is reached
## Override this to add custom behavior when piercing limit is hit
func on_max_piercing_reached(_projectile: Node, _context: Dictionary) -> void:
	pass
