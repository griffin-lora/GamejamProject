extends Node2D

export var mode := 1

onready var preview = $Preview
onready var objects = $Objects

export var selected_obstacle := 0
var id_mapper

export var placing_obstacles = true

export var placing := false
export var erasing := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	id_mapper = load("res://actors/obstacles/ids.tres")
	
	for object in GlobalVars.level_data.objects:
		var object_scene = GlobalVars.scene_cache[object.id].instance()
		object_scene.mode = mode
		object_scene.set_properties()
		var index = 0
		for property in object_scene.editable_properties:
			object_scene[property] = object.properties[index]
			index += 1
		objects.add_child(object_scene)
		
func update_selected_obstacle():
	var object_resource = load("res://actors/obstacles/" + id_mapper.ids[selected_obstacle] + ".tres")
	preview.texture = object_resource.preview
	
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var mouse_screen_pos = get_viewport().get_mouse_position()
	preview.position = Vector2(stepify(mouse_pos.x, 16), stepify(mouse_pos.y, 16))
	preview.visible = placing_obstacles
	
	if placing and placing_obstacles and mouse_screen_pos.y < 932:
		var object_resource = load("res://actors/obstacles/" + id_mapper.ids[selected_obstacle] + ".tres")
		var object_scene = load(object_resource.scene_path).instance()
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
			GlobalVars.level_data.objects.clear()
			for object in objects.get_children():
				var level_object = {
					"id": object.id,
					"properties": []
				}
				for property in object.editable_properties:
					level_object.properties.append(object[property])
				GlobalVars.level_data.objects.append(level_object)

	elif erasing and placing_obstacles and mouse_screen_pos.y < 932:
		var objects_found = get_objects_at_position(preview.position)
		for object in objects_found:
			object.queue_free()

func get_objects_at_position(test_position):
	var objects_found = []
	for object in objects.get_children():
		if object.intersects_pos(test_position):
			objects_found.append(object)
	return objects_found
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			placing = true
		elif event.button_index == 1 and !event.pressed:
			placing = false
		
		if event.button_index == 2 and event.pressed:
			erasing = true
		elif event.button_index == 2 and !event.pressed:
			erasing = false

	if event.is_action_pressed("test"):
		test_level()

func test_level():
	GlobalVars.ability_recharge_ct = GlobalVars.ability_recharge_time
	GlobalVars.pre_death_ability_recharge_ct = GlobalVars.ability_recharge_ct
	GlobalVars.slow_ticker = 0
	GlobalVars.is_slow = false
	GlobalVars.score = 0
	GlobalVars.level_data.objects.clear()
	for object in objects.get_children():
		var level_object = {
			"id": object.id,
			"properties": []
		}
		for property in object.editable_properties:
			level_object.properties.append(object[property])
		GlobalVars.level_data.objects.append(level_object)
	get_tree().change_scene("res://levels/level_loader.tscn")
