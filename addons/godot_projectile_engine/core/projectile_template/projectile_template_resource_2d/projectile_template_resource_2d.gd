extends ProjectileTemplate2D
class_name ProjectileTemplateResource2D


@export var move_speed : float = 100
@export var projectile_pooling_amount : int = 500

@export var life_time_max : float = 10.0
@export var life_distance_max : float = 300.0

@export_group("Texture")

@export var texture : Texture2D
@export var texture_visible : bool = true
@export var texture_z_index : int = 0

#Rotate the texture based on the direction.
@export var texture_modulate : Color = Color(1, 1, 1, 1)
@export var texture_rotate_direction: bool = false

@export_range(-360.0, 360.0) var rotation : float
@export var scale : Vector2 = Vector2.ONE

@export_subgroup("Animation")
@export var use_animation : bool = false
@export var animated_sprite : SpriteFrames
@export var animation_name : String


@export_group("Collision")
@export var collision_shape : Shape2D
@export_flags_2d_physics var collision_layer : int = 0:
	set(value):
		collision_layer = value
		if projectile_area_rid:
			PhysicsServer2D.area_set_collision_layer(projectile_area_rid, collision_layer)

@export_flags_2d_physics var collision_mask : int = 0:
	set(value):
		collision_mask = value
		if projectile_area_rid:
			PhysicsServer2D.area_set_collision_layer(projectile_area_rid, collision_mask)

@export_group("Trigger")
@export var trigger_name : String
@export var trigger_conditions: Array[ProjectileTriggerCondition2D]


@export_group("Template Module")
##@experimental: 
##Projectile Template Component is an experimental component for modifying properties of 
##ProjectileInstance2D based on ProjectileTemplate2D in real-time
@export var template_modules : Array[ProjectileTemplateModule]

var projectile_area_rid : RID
