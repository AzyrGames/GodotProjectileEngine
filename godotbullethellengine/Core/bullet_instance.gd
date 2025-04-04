extends Node
class_name BulletInstance2D


var transform : Transform2D

var global_position : Vector2 = Vector2.ZERO
var rotation : float = 0
var scale : Vector2 = Vector2.ONE
var skew : float = 0


var move_direction : Vector2 = Vector2.ONE
var move_speed : float = 120
var velocity : Vector2

var collision_shape_rid : RID
var collision_shape_idx : int


var animation_frames : int

var life_time : float
@export var max_life_time : float = 5


