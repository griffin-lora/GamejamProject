extends Actor

var center_pos := Vector2()
var path_index = 0

onready var sprite = $Sprite
onready var path_node = get_node(path)

export var reaction_speed = 17.5
export var fly_speed = 5
export var rotation_speed = 1

export var path_interpolation_speed = 15
export var path : NodePath
var path_points
var target

var base_rotation = 0

func _ready():
	center_pos = position
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if path:
		path_points = path_node.curve.get_baked_points()
	target = path_points[path_index]
		
func _physics_process(delta):
	if center_pos.distance_to(target) < fly_speed:
		path_index = clamp(path_index + 1, 0, path_points.size() - 1)
		target = path_points[path_index]
		
	if path_index > 0:
		var last_target = path_points[path_index - 1]
		var dx = target.x - last_target.x
		var dy = target.y - last_target.y
		var x_normal = Vector2(-dy, dx)
		var y_normal = Vector2(dy, -dx)
		base_rotation = y_normal.angle() + PI/2
		
	center_pos += (target - center_pos).normalized() * fly_speed
		
	var mouse_pos = get_global_mouse_position()
	position = position.linear_interpolate(mouse_pos, delta * reaction_speed)
	sprite.rotation = lerp(sprite.rotation, base_rotation, delta * rotation_speed)
	#lerp(sprite.rotation_degrees, clamp(mouse_pos.y - position.y, -30, 30), delta * rotation_speed) + rad2deg(base_rotation)
