extends BehaviorVariable
class_name BehaviorVariablePiercing

var current_piercing_count: int = 0
var pierced_targets: Array[Node] = []
var is_piercing_just_done : bool = false
var is_piercing_done : bool = false
var is_overlap_piercing : bool = false