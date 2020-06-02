extends Node2D

export var mode := 0
export var path : NodePath # haha funny coindicnddencdedcwd
export var objects : NodePath

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	var path_node = get_node(path)
	path_node.curve.clear_points()
	path_node.curve.set_bake_interval(15)
	
	var path_points = path_node.curve.get_baked_points()
	for point in GlobalVars.level_data.path_points:
		path_node.curve.add_point(point[0], point[1], point[2])

	var objects_node = get_node(objects)
	var id_mapper = load("res://actors/obstacles/ids.tres")
	for object in GlobalVars.level_data.objects:
		var object_resource = load("res://actors/obstacles/" + id_mapper.ids[object.id] + ".tres")
		var object_scene = load(object_resource.scene_path).instance()
		object_scene.set_properties()
		var index = 0
		for property in object_scene.editable_properties:
			object_scene[property] = object.properties[index]
			index += 1
		objects_node.add_child(object_scene)

func _input(event):
	if event.is_action_pressed("test"):
		get_tree().change_scene("res://editor.tscn")
