extends Object
class_name BulletInstance2D


var texture_rotate_direction : bool = false

var animation_frame : int
var animation_frame_tick : int = 1


var velocity : Vector2 = Vector2.ZERO

var move_speed : float = 100
var base_move_speed : float = 100
var move_speed_mod : float = 1.0

var base_move_direction : Vector2 = Vector2.ZERO
var move_direction : Vector2 = Vector2.ZERO

var direction_rotation_speed : float = 0.0
var texture_rotation_speed : float = 0.0


var transform : Transform2D
var texture_rotation : float = 0
var scale : Vector2 = Vector2.ONE
var skew : float = 0
var global_position : Vector2 = Vector2.ZERO


var life_time : float
var life_time_tick : int
var life_time_max : float = 5

var life_distance : float 
var life_distance_max : float = 99999
