extends Node2D

export var mode := 1

onready var preview = $Preview
onready var objects = $Objects

var selected_object := 0
var id_mapper

func _ready():
	id_mapper = load("res://actors/obstacles/ids.tres")
	
	var id_mapper = load("res://actors/obstacles/ids.tres")
	for object in GlobalVars.level_data.objects:
		var object_scene = load("res://actors/obstacles/" + id_mapper.ids[object.id] + ".tscn").instance()
		object_scene.set_properties()
		var index = 0
		for property in object_scene.editable_properties:
			object_scene[property] = object.properties[index]
			index += 1
		objects.add_child(object_scene)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	preview.position = Vector2(stepify(mouse_pos.x, 16), stepify(mouse_pos.y, 16))
	
	if Input.is_action_just_pressed("place"): # holding it down made it lag and im too lazy to find a better solution so don't ree me
		var object_scene = load("res://actors/obstacles/" + id_mapper.ids[selected_object] + ".tscn").instance()
		object_scene.set_properties()

		var invalid = false
		var combinations = []
		for x in (object_scene.tiles_using.x):
			for y in (object_scene.tiles_using.y):
				combinations.append(Vector2(preview.position.x + (x*16), preview.position.y + (y*16)))
			
		for test_pos in combinations:
			if !get_objects_at_position(test_pos).empty():
				invalid = true
				
		if !invalid:
			object_scene.position = preview.position
			object_scene.mode = mode
			objects.add_child(object_scene)

	elif Input.is_action_pressed("erase"):
		var objects_found = get_objects_at_position(preview.position)
		for object in objects_found:
			object.queue_free()

func get_objects_at_position(test_position):
	var objects_found = []
	for object in objects.get_children():
		if object.intersects_pos(test_position):
			objects_found.append(object)
	return objects_found
	
func _input(event):
	if event.is_action_pressed("test"):
		for object in objects.get_children():
			var level_object = {
				"id": object.id,
				"properties": []
			}
			for property in object.editable_properties:
				level_object.properties.append(object[property])
			GlobalVars.level_data.objects.append(level_object)
		get_tree().change_scene("res://levels/level_loader.tscn")
