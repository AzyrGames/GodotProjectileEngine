@icon("uid://vyba3qyd64yj")
extends Area2D
class_name ProjectileBoundary2D

func _ready() -> void:
	ProjectileEngine.projectile_boundary_2d = self