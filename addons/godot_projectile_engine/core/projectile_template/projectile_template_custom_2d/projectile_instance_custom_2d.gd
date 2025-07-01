extends Object
class_name ProjectileInstanceCustom2D

var behavior_context : Dictionary
var behavior_update_context : Dictionary
var behavior_persist_context : Dictionary

var area_index : int
var area_rid : RID

var speed : float
var base_speed : float

var direction : Vector2
var base_direction : Vector2
var raw_direction : Vector2
var direction_addition : Vector2
var direction_rotation : float
var direction_final : Vector2

var velocity : Vector2

var global_position : Vector2
var rotation :float
# var texture_rotation : float
var scale : Vector2 = Vector2.ONE

var transform : Transform2D


var life_time : float
var life_distance : float 

var trigger_count : int = 0