extends Path2D

func _ready():
	curve.set_bake_interval(15)
	curve.tessellate(5, 4)

func _draw():
	var points = curve.get_baked_points()
	var index = 0
	for point in points:
		if index < points.size() - 1:
			draw_polyline(points, Color(1, 0, 0), 3, true)
		index += 1

func _input(event):
	if event.is_action_pressed("add_point"):
		var path_points = curve.get_baked_points()
		var mouse_pos = Vector2(stepify(get_global_mouse_position().x, 16), stepify(get_global_mouse_position().y, 16))
		
		var last_target = path_points[path_points.size() - 1]
		var target = mouse_pos
		var dx = target.x - last_target.x
		var dy = target.y - last_target.y
		var x_normal = Vector2(-dy, dx)
		var y_normal = Vector2(dy, -dx)
		curve.add_point(mouse_pos, -y_normal / 5)
		update()
