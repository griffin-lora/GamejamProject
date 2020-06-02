extends Path2D

# i swear if i do this and then you tell me it was supposed to be this way i will chop your hands off

var sprites = []

var spline_length := 30

func _get_spline(i):
	var last_point = _get_point(i - 1)
	var next_point = _get_point(i + 1)
	var spline = last_point.direction_to(next_point) * spline_length
	return spline

func _get_point(i):
	var point_count = curve.get_point_count()
	i = wrapi(i, 0, point_count - 1)
	return curve.get_point_position(i)

func smooth(value):
	if not value: return

	var point_count = curve.get_point_count()
	for i in point_count:
		var spline = _get_spline(i)
		curve.set_point_in(i, -spline)
		curve.set_point_out(i, spline)

func add_point(p, add_to_data = false, v = Vector2(), v2 = Vector2()):
	curve.add_point(p, v, v2)
	if add_to_data:
		GlobalVars.level_data.path_points.append([p, v, v2])
	var sprite : TextureButton = load("res://src/point_sprite.tscn").instance()
	sprites.append(sprite)
	var id = 0
	if sprites.size() > 0:
		id = sprites.size() - 1
	sprite.visualizer = self
	sprite.data_id = id
	sprite.data_point = GlobalVars.level_data.path_points[GlobalVars.level_data.path_points.size() - 1]
	sprite.offset = (Vector2(sprite.margin_right, sprite.margin_bottom) / 2)
	sprite.rect_position = p - sprite.offset
	add_child(sprite)
	#smooth(1)
	update()

func _ready():
	yield(get_tree(), "physics_frame")
	curve.clear_points()
	curve.set_bake_interval(15)

	for point in GlobalVars.level_data.path_points:
		print(point)
		add_point(point[0], point[1], point[2])
	
	curve.tessellate(5, 4)

func _draw():
	var points = curve.get_baked_points()
	draw_polyline(points, Color(1, 0, 0), 3, true)

func _input(event):		
	if event.is_action_pressed("add_point"):
		var path_points = GlobalVars.level_data.path_points
		var mouse_pos = Vector2(stepify(get_global_mouse_position().x, 16), stepify(get_global_mouse_position().y, 16))
		
		var last_target = path_points[path_points.size() - 1][0]
		var target = mouse_pos
		var dx = target.x - last_target.x
		var dy = target.y - last_target.y
		var x_normal = Vector2(-dy, dx)
		var y_normal = Vector2(dy, -dx)
		add_point(mouse_pos, true)
