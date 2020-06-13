extends Node2D

export var mode := 0
export var won := false
export var path : NodePath # haha funny coindicnddencdedcwd
export var objects : NodePath

onready var background = $CanvasLayer/Sprite

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	var path_node = get_node(path)
	path_node.curve.clear_points()
	path_node.curve.set_bake_interval(15)
	
	var arrow_scene = load("res://actors/arrow.tscn")
	
	var path_points = path_node.curve.get_baked_points()
	var path_index = 0
	var last_rot = 0
	for point in GlobalVars.level_data.path_points:
		path_node.curve.add_point(point)
		if path_index > 0:
			var target = point
			var last_target = GlobalVars.level_data.path_points[path_index - 1]
			var dx = target.x - last_target.x
			var dy = target.y - last_target.y
			var x_normal = Vector2(-dy, dx)
			var y_normal = Vector2(dy, -dx)
			if last_rot != y_normal.angle() + PI/2:
				var arrow_node = arrow_scene.instance()
				arrow_node.rotation = y_normal.angle() + PI/2
				arrow_node.position = last_target
				add_child(arrow_node)
			last_rot = y_normal.angle() + PI/2
		path_index += 1

	var objects_node = get_node(objects)
	for object in GlobalVars.level_data.objects:
		var object_scene = GlobalVars.scene_cache[object.id].instance()
		object_scene.set_properties()
		var index = 0
		for property in object_scene.editable_properties:
			object_scene[property] = object.properties[index]
			index += 1
		objects_node.add_child(object_scene)
		
	if GlobalVars.level_data.theme == 1:
		background.texture = load("res://assets/alt_themes/bkg_underground.png")
		background.material.set_shader_param("warp_amount", 0.002)
	elif GlobalVars.level_data.theme == 2:
		background.texture = load("res://assets/alt_themes/bkg_snow.png")
	elif GlobalVars.level_data.theme == 3:
		background.texture = load("res://assets/alt_themes/bkg_ghost.png")
		background.material.set_shader_param("warp_amount", 0.01)
	elif GlobalVars.level_data.theme == 4:
		background.texture = load("res://assets/alt_themes/bkg_castle.png")
	elif GlobalVars.level_data.theme == 5:
		background.texture = load("res://assets/alt_themes/bkg_sky.png")

func _input(event):
	if event.is_action_pressed("test") and GlobalVars.is_editor_mode:
		for index in range(8):
			yield(get_tree(), "physics_frame")
		get_tree().change_scene("res://editor.tscn")
