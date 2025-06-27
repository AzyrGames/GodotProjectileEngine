extends Object
class_name ProjectileInstance2D


var area_index : int
var area_rid : RID

var life_time : float
var life_time_second : float
var life_time_tick : int
var life_distance : float 

var transform : Transform2D

var texture_rotate_direction : bool = false

var animation_frame : int
var animation_frame_tick : int = 1


var velocity : Vector2 = Vector2.ZERO

var move_speed : float = 100
var base_move_speed : float = 100
var move_speed_modifier : float = 1.0
var move_speed_static : float = 0


var base_move_direction : Vector2 = Vector2.ZERO
var move_direction : Vector2 = Vector2.ZERO

var base_texture_rotation : float = 0
var texture_rotation : float = 0
var base_texture_scale : Vector2 = Vector2.ONE

var texture_scale : Vector2 = Vector2.ONE
var texture_skew : float = 0.0
var global_position : Vector2 = Vector2.ZERO


var is_trigger : bool = false
var trigger_dict : Dictionary