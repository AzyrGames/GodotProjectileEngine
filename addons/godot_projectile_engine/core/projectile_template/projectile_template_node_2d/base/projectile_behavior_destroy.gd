extends ProjectileBehavior
class_name ProjectileBehaviorDestroy

## Base class for all projectile destroy behaviors in the projectile engine.
##
## Provides core functionality and interface that all destroy behavior implementations
## must follow. Destroy behaviors determine when and how projectiles are destroyed.


## Whether to emit a signal when destroying	
@export var emit_destroy_signal: bool = true

## Signal emitted when projectile is destroyed by this behavior
signal projectile_destroyed(projectile: Node, behavior: ProjectileBehaviorDestroy)

## Processes the destroy behavior and returns whether projectile should be destroyed
## Returns bool: true if projectile should be destroyed, false otherwise
func process_behavior(_value, _context: Dictionary) -> bool:
	return false

## Called when the projectile is about to be destroyed
## Override this to add custom destruction effects
func on_destroy(_projectile: Node, _context: Dictionary) -> void:
	pass

## Helper method to destroy the projectile
func destroy_projectile(_projectile: Node, _context: Dictionary) -> void:
	if emit_destroy_signal:
		projectile_destroyed.emit(_projectile, self)
	
	on_destroy(_projectile, _context)
	
	if is_instance_valid(_projectile):
		_projectile.queue_free()
