@icon("uid://b848vxv35dbv7")
extends Projectile2D
class_name ProjectileLaser2D

enum TEXTUREMODE {
	None, 
	Tile, 
	Stretch
	}

enum CAP {
	None, 
	Box, 
	Round
	}

enum LaserType {
	STRAIGHT,
	CURVY
}

@export_category("ProjectileLaser2D")

@export var laser_type : LaserType = LaserType.STRAIGHT
@export var start_full_length : bool = true
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var laser_length : float = 64.0:
	set(value):
		laser_length = value
		update_laser_line_2d()
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var laser_width : float = 16.0:
	set(value):
		laser_width = value
		update_laser_line_2d()
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var collision_width : float = 16.0:
	set(value):
		collision_width = value
		update_laser_line_2d()

@export_category("Texture")
@export var texture : Texture2D = null:
	set(value):
		texture = value
		update_laser_line_2d()
@export var gradient : Gradient:
	set(value):
		gradient = value
		update_laser_line_2d()
@export var texture_mode : Line2D.LineTextureMode = Line2D.LineTextureMode.LINE_TEXTURE_STRETCH:
	set(value):
		texture_mode = value
		update_laser_line_2d()
@export var width_curve : Curve:
	set(value):
		width_curve = value
		update_laser_line_2d()
@export var begin_cap_mode : Line2D.LineCapMode:
	set(value):
		begin_cap_mode = value
		update_laser_line_2d()
@export var end_cap_mode : Line2D.LineCapMode:
	set(value):
		end_cap_mode = value
		update_laser_line_2d()

var laser_line_2d : Line2D

var _current_laser_length: float = 0

func _ready() -> void:
	apply_custom_data()
	collision_width = laser_width + 2
	super()
	pass


func setup_projectile_2d() -> void:
	init_base_properties()
	setup_projectile_behavior()
	update_projectile_2d(get_physics_process_delta_time())
	setup_collision_raycast()
	setup_projectile_laser()
	pass

func _physics_process(delta: float) -> void:
	super(delta)

	update_collision_raycast()

	if start_full_length:
		laser_line_2d.clear_points()
		laser_line_2d.add_point(laser_line_2d.position)
		laser_line_2d.add_point(laser_line_2d.position + direction * _current_laser_length)
		collision_shape.position = laser_line_2d.position + direction * _current_laser_length / 2
		collision_shape.shape.size = Vector2(_current_laser_length, collision_width)
		collision_shape.rotation = direction.angle()
	else:
		laser_line_2d.clear_points()
		match laser_type:
			LaserType.STRAIGHT:
				if life_distance < laser_length:
					# velocity = Vector2.ZERO
					laser_line_2d.add_point(laser_line_2d.position - direction_final * life_distance)
					laser_line_2d.add_point(laser_line_2d.position)
					collision_shape.global_position = global_position - direction_final * life_distance / 2
					collision_shape.shape.size = Vector2(life_distance, collision_width)
					# collision_shape.rotation = direction_rotation
				else:
					laser_line_2d.add_point(laser_line_2d.position - direction_final * laser_length)
					laser_line_2d.add_point(laser_line_2d.position)
					collision_shape.global_position = global_position - direction_final * laser_length / 2
					collision_shape.shape.size = Vector2(laser_length, collision_width)
					# collision_shape.rotation = direction_rotation
			_:
				pass
	# print("lazer: ", collision_shape.global_position)
	
	pass


func update_laser_line_2d() -> void:
	if !laser_line_2d:
		return
	update_collision_raycast()
	laser_line_2d.texture = texture
	laser_line_2d.texture_mode = texture_mode
	laser_line_2d.width_curve = width_curve
	laser_line_2d.joint_mode = Line2D.LINE_JOINT_ROUND
	laser_line_2d.begin_cap_mode = begin_cap_mode
	laser_line_2d.end_cap_mode = end_cap_mode
	laser_line_2d.width = laser_width
	laser_line_2d.clear_points()
	match laser_type:
		LaserType.STRAIGHT:
			laser_line_2d.add_point(laser_line_2d.position)
			laser_line_2d.add_point(laser_line_2d.position + direction * _current_laser_length)
		_:
			pass
	collision_shape.position = laser_line_2d.position + direction * _current_laser_length / 2
	collision_shape.shape.size = Vector2(_current_laser_length, collision_width)
	collision_shape.rotation = direction.angle()
	# collision_shape.rotation = direction_rotation

	pass

func setup_projectile_laser() -> void:
	if laser_line_2d:
		laser_line_2d.queue_free()
	laser_line_2d = Line2D.new()
	add_child(laser_line_2d, true)
	laser_line_2d.clear_points()
	if !collision_shape:
		var _new_collision_shape = CollisionShape2D.new()
		add_child(_new_collision_shape)
		collision_shape = _new_collision_shape
	match laser_type:
		LaserType.STRAIGHT:
			var _rect_shape = RectangleShape2D.new()
			collision_shape.shape = _rect_shape
			if start_full_length:
				_current_laser_length = laser_length
				pass
			else:
				collision_shape.position = position
				collision_shape.shape.size = Vector2(1, collision_width)
	update_laser_line_2d()
	pass



var collision_raycast: RayCast2D

func setup_collision_raycast() -> void:
	collision_raycast = RayCast2D.new()
	add_child(collision_raycast)
	collision_raycast.set_collision_mask_value(6, true)
	pass


func update_collision_raycast() -> void:
	collision_raycast.global_position = laser_line_2d.global_position
	collision_raycast.target_position = direction * laser_length
	collision_raycast.force_raycast_update()
	if collision_raycast.is_colliding():
		_current_laser_length = collision_raycast.global_position.distance_to(collision_raycast.get_collision_point())
	else:
		_current_laser_length = laser_length

	pass
