extends Path2D

# i swear if i do this and then you tell me it was supposed to be this way i will chop your hands off

export var editor : NodePath
var sprites = []

onready var editor_node = get_node(editor)

func add_point(p, add_to_data = false, v = Vector2(), v2 = Vector2()):
	curve.add_point(p, v, v2)
	if add_to_data:
		GlobalVars.level_data.path_points.append(p)
	var sprite : TextureButton = load("res://src/point_sprite.tscn").instance()
	sprite.visualizer = self
	#sprite.data_point = GlobalVars.level_data.path_points[GlobalVars.level_data.path_points.size() - 1]
	sprite.point_index = sprites.size()
	sprite.rect_position = p - (sprite.rect_size / 2)
	sprites.append(sprite)
	add_child(sprite)
	update()

func remove_point(index):
	curve.remove_point(index)
	GlobalVars.level_data.path_points.remove(index)
	for sprite in sprites:
		sprite.queue_free()
	sprites = []
	for i in range(0, curve.get_point_count()):
		var p = curve.get_point_position(i)
		var sprite : TextureButton = load("res://src/point_sprite.tscn").instance()
		sprite.visualizer = self
		#sprite.data_point = GlobalVars.level_data.path_points[GlobalVars.level_data.path_points.size() - 1]
		sprite.point_index = sprites.size()
		sprite.rect_position = p - (sprite.rect_size / 2)
		sprites.append(sprite)
		add_child(sprite)
		update()

func _ready():
	yield(get_tree(), "physics_frame")
	curve.clear_points()
	curve.set_bake_interval(15)

	for point in GlobalVars.level_data.path_points:
		add_point(point)
	
	curve.tessellate(5, 4)
	
func _physics_process(delta):
	update()

func _draw():
	var points = curve.get_baked_points()
	draw_polyline(points, Color(1, 0, 0), 3, true)
	if !editor_node.placing_obstacles:
		var mouse_pos = get_global_mouse_position()
		mouse_pos = Vector2(stepify(mouse_pos.x, 64), stepify(mouse_pos.y, 64))
		draw_line(GlobalVars.level_data.path_points[GlobalVars.level_data.path_points.size() - 1], mouse_pos, Color(1, 0.5, 0.5), 3)

func _unhandled_input(event):
	var mouse_screen_pos = get_viewport().get_mouse_position()
	if event is InputEventMouseButton and event.pressed and !editor_node.placing_obstacles and mouse_screen_pos.y < 932:
		var path_points = GlobalVars.level_data.path_points
		var mouse_pos = Vector2(stepify(get_global_mouse_position().x, 64), stepify(get_global_mouse_position().y, 64))
		
		var last_target = path_points[path_points.size() - 1]
		var target = mouse_pos
		var dx = target.x - last_target.x
		var dy = target.y - last_target.y
		var x_normal = Vector2(-dy, dx)
		var y_normal = Vector2(dy, -dx)
		add_point(mouse_pos, true)
