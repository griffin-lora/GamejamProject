extends Button

export var menu_name := "ObstaclesPage"

var start_rect_pos : Vector2

func _ready():
	start_rect_pos = rect_position

func _process(delta):
	if is_hovered() and !pressed:
		modulate = Color(0.85, 0.85, 0.95)
		rect_scale = rect_scale.linear_interpolate(Vector2(1.08, 1.08), delta * 8)
		rect_position = rect_position.linear_interpolate(start_rect_pos - (rect_size * .04), delta * 8)
	else:
		modulate = Color(1, 1, 1)
		rect_scale = rect_scale.linear_interpolate(Vector2(1, 1), delta * 8)
		rect_position = rect_position.linear_interpolate(start_rect_pos, delta * 8)

func _pressed():
	get_parent().visible = false
	get_parent().get_parent().get_node(menu_name).visible = true
