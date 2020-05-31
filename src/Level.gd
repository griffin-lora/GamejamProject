extends Node2D

export var mode := 0
export var path : NodePath # haha funny coindicnddencdedcwd
export var objects : NodePath

func _ready():
	var path_node = get_node(path)
	path_node.curve.clear_points()
	path_node.curve.add_point(Vector2(32, 960))
	path_node.curve.add_point(Vector2(640, 960))
	path_node.curve.set_bake_interval(15)
	
	var path_points = path_node.curve.get_baked_points()
	for point in GlobalVars.level_data.path_points:
		var last_target = path_points[path_points.size() - 1]
		var target = point
		var dx = target.x - last_target.x
		var dy = target.y - last_target.y
		var x_normal = Vector2(-dy, dx)
		var y_normal = Vector2(dy, -dx)
		path_node.curve.add_point(point, -y_normal / 5)

	var objects_node = get_node(objects)
	var id_mapper = load("res://actors/obstacles/ids.tres")
	for object in GlobalVars.level_data.objects:
		var object_scene = load("res://actors/obstacles/" + id_mapper.ids[object.id] + ".tscn").instance()
		object_scene.set_properties()
		var index = 0
		for property in object_scene.editable_properties:
			object_scene[property] = object.properties[index]
			index += 1
		objects_node.add_child(object_scene)
