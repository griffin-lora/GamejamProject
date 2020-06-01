extends Obstacle
export var parts := 2
export var tiles_using := Vector2(2, 4)

func set_properties():
	editable_properties = ["position", "parts"]

func _ready():
	update_parts()

func update_parts():
	middle_part.rect_size.y = parts * 16
	bottom_part.position.y = 16 * (parts + 1)
	
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(8 * tiles_using.x, ((parts + 2) * 16) / 2)
	
	area.position.x = 8 * tiles_using.x
	editor_area.position.x = 8 * tiles_using.x
	
	area.position.y = ((parts + 2) * 16) / 2
	editor_area.position.y = ((parts + 2) * 16) / 2
	
	area_collision.shape = shape
	editor_collision.shape = shape
	
	var objects = get_parent()
	GlobalVars.level_data.objects.clear()
	for object in objects.get_children():
		var level_object = {
			"id": object.id,
			"properties": []
		}
		for property in object.editable_properties:
			level_object.properties.append(object[property])
		GlobalVars.level_data.objects.append(level_object)
		
	tiles_using.y = parts + 2

func _input(event):
	if event is InputEventMouseButton:
		var rounded_pos = Vector2(stepify(get_global_mouse_position().x, 16), stepify(get_global_mouse_position().y, 16))
		if event.is_pressed() and intersects_pos(rounded_pos):
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
