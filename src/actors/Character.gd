extends Actor

var center_pos := Vector2()
var path_index = 0

onready var sprite = $Sprite
onready var path_node = get_node(path)

export var reaction_speed = 17.5
export var fly_speed = 15
export var rotation_speed = 3

export var path_interpolation_speed = 15
export var path : NodePath
var path_points
var target
var move_normal = Vector2()

var base_rotation = 0

func _ready():
	center_pos = position
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if path:
		path_node.curve.set_bake_interval(fly_speed)
		path_points = path_node.curve.get_baked_points()
		path_node.curve.tessellate(5, 4)
	target = path_points[path_index]
	move_normal = (target - center_pos).normalized()
		
func _physics_process(delta):
	if center_pos.distance_to(target) < fly_speed and path_index + 1 < path_points.size():
		path_index += 1
		target = path_points[path_index]
		move_normal = (target - center_pos).normalized()
		
	if path_index > 0:
		var last_target = path_points[path_index - 1]
		var dx = target.x - last_target.x
		var dy = target.y - last_target.y
		var x_normal = Vector2(-dy, dx)
		var y_normal = Vector2(dy, -dx)
		base_rotation = y_normal.angle() + PI/2
		
	center_pos += move_normal * fly_speed
		
	var mouse_pos = get_global_mouse_position()
	position = position.linear_interpolate(mouse_pos, delta * reaction_speed)
	sprite.rotation = lerp_angle(sprite.rotation, base_rotation, delta * rotation_speed)
	#lerp(sprite.rotation_degrees, clamp(mouse_pos.y - position.y, -30, 30), delta * rotation_speed) + rad2deg(base_rotation)
