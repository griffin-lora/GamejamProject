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
	
	var path_points = path_node.curve.get_baked_points()
	for point in GlobalVars.level_data.path_points:
		path_node.curve.add_point(point)

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

func _input(event):
	if event.is_action_pressed("test") or (event.is_action_pressed("place") and won):
		for index in range(8):
			yield(get_tree(), "physics_frame")
		get_tree().change_scene("res://editor.tscn")
