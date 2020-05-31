extends Obstacle
export var parts := 2

func set_properties():
	editable_properties = ["position", "parts"]

func _ready():
	update_parts()

func update_parts():
	middle_part.scale.y = parts
	bottom_part.position.y = 16 * (parts + 1)
	
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(16, ((parts + 2) * 16) / 2)
	
	area.position.y = ((parts + 2) * 16) / 2
	editor_area.position.y = ((parts + 2) * 16) / 2
	
	area_collision.shape = shape
	editor_collision.shape = shape

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and intersects_pos(get_global_mouse_position()):
			if event.button_index == BUTTON_WHEEL_UP:
				parts = clamp(parts + 1, 0, 24)
				update_parts()
			if event.button_index == BUTTON_WHEEL_DOWN:
				parts = clamp(parts - 1, 0, 24)	
				update_parts()
	elif event.is_action_pressed("extend_terrain"):
		parts = clamp(parts + 1, 0, 24)
		update_parts()
	elif event.is_action_pressed("shorten_terrain"):
		parts = clamp(parts - 1, 0, 24)
		update_parts()
