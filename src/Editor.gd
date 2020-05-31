extends Node2D

onready var preview = $Preview

var selected_object := 0
var id_mapper

func _ready():
	id_mapper = load("res://actors/obstacles/ids.tres")

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	preview.position = Vector2(stepify(mouse_pos.x, 16), stepify(mouse_pos.y, 16))

func _input(event):
	var object_scene = load("res://actors/obstacles/" + id_mapper.ids[selected_object] + ".tscn").instance()
	object_scene.position = preview.position
