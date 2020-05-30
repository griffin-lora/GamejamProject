extends Node

onready var area = $Area2D

func collide(col_area):
	if col_area.name == "CharArea":
		var character = col_area.get_node("../")
		character.kill()

func _ready():
	print("eee")
	area.connect("area_entered", self, "collide")
