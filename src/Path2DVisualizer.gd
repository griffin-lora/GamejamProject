extends Path2D

# i swear if i do this and then you tell me it was supposed to be this way i will chop your hands off

var sprites = []

func add_point(p):
	curve.add_point(p)
	var sprite : TextureButton = load("res://src/point_sprite.tscn").instance()
	sprite.rect_position = p - (sprite.rect_size / 2)
	add_child(sprite)

func add_point2(p, v):
	curve.add_point(p, v) #because i have no clue how this works
	var sprite : TextureButton = load("res://src/point_sprite.tscn").instance()
	sprite.rect_position = p - (sprite.rect_size / 2)
	add_child(sprite)

func _ready():
	curve.clear_points()
	add_point(Vector2(32, 960))
	add_point(Vector2(640, 960))
	curve.set_bake_interval(15)

	var path_points = curve.get_baked_points()
	for point in GlobalVars.level_data.path_points:
		var last_target = path_points[path_points.size() - 1]
		var target = point
		var dx = target.x - last_target.x
		var dy = target.y - last_target.y
		var x_normal = Vector2(-dy, dx)
		var y_normal = Vector2(dy, -dx)
		add_point2(point, -y_normal / 5)
	
	curve.tessellate(5, 4)

func _draw():
	var points = curve.get_baked_points()
	draw_polyline(points, Color(1, 0, 0), 3, true)

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
		add_point2(mouse_pos, -y_normal / 5)
		GlobalVars.level_data.path_points.append(mouse_pos)
		update()
