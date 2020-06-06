extends TextureButton

export var obstacle_id := 0
export var editor_path : NodePath
export var is_theme := false

onready var editor = get_node(editor_path)

var start_rect_pos : Vector2
var start_scale : Vector2

func _ready():
	start_rect_pos = rect_position
	start_scale = rect_scale

func _process(delta):
	if is_hovered() and !pressed:
		modulate = Color(0.85, 0.85, 0.95)
		rect_scale = rect_scale.linear_interpolate(start_scale * 1.08, delta * 8)
		rect_position = rect_position.linear_interpolate(start_rect_pos - (rect_size * .04)*rect_scale, delta * 8)
	else:
		modulate = Color(1, 1, 1)
		rect_scale = rect_scale.linear_interpolate(start_scale, delta * 8)
		rect_position = rect_position.linear_interpolate(start_rect_pos, delta * 8)

func _pressed():
	if !is_theme:
		editor.selected_obstacle = obstacle_id
		editor.update_selected_obstacle()
		editor.placing_obstacles = true
	else:
		GlobalVars.level_data.theme = obstacle_id
		get_tree().reload_current_scene()
