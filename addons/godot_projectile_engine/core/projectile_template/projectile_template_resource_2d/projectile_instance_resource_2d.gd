extends ProjectileInstance2D
class_name ProjectileInstanceResource2D



# var texture_rotate_direction : bool = false

var animation_frame : int
var animation_frame_tick : int = 1
var base_speed : float = 100
var speed_modifier : float = 1.0
var speed_static : float = 0


var base_direction : Vector2 = Vector2.ZERO

var base_texture_rotation : float = 0
var texture_rotation : float = 0
var base_texture_scale : Vector2 = Vector2.ONE

var texture_scale : Vector2 = Vector2.ONE
var texture_skew : float = 0.0


var is_trigger : bool = false
var trigger_dict : Dictionary