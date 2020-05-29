extends Actor

var center_pos := Vector2()
var path_index = 0
var progress = 0

onready var sprite = $Sprite
onready var path_node = get_node(path)

export var reaction_speed = 17.5
export var rotation_speed = 12.5
export var path_interpolation_speed = 0.3
export var path : NodePath

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	var last_path_pos = Vector2()
	if path_node.is_path_index(path_index - 1):
		last_path_pos = path_node.get_path_pos(path_index - 1)
	var path_pos = path_node.get_path_pos(path_index)
	center_pos = last_path_pos.linear_interpolate(path_pos, progress)
	var mouse_pos = get_global_mouse_position()
	position = position.linear_interpolate(mouse_pos, delta * reaction_speed)
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, clamp(mouse_pos.y - position.y, -35, 35), delta * rotation_speed)

	progress += delta * path_interpolation_speed
	if progress >= 1 and path_node.is_path_index(path_index + 1):
		progress = 0
		path_index = path_index + 1
