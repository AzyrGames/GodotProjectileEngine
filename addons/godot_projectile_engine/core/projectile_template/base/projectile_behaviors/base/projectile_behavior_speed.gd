extends ProjectileBehavior
class_name ProjectileBehaviorSpeed

enum SpeedModifyMethod{
	## Addition value to the current speed
	ADDITION,
	## Addition value overtime the the current speed
	ADDITION_OVER_TIME,
	## Multiply value to the current speed
	MULTIPLICATION,
	## Multiply value to the base speed
	MULTIPLICATION_OVER_BASE,
	## Override the current speed
	OVERRIDE,
}


func process_behavior(_value: float, _context: Dictionary) -> Dictionary:
	return {ProjectileEngine.SpeedModify.SPEED_OVERWRITE : _value}

