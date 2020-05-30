extends Actor

onready var area = $Area2D

var type = "Obstacle"

func collide(col_area):
	if col_area.name == "CharArea":
		var character = col_area.get_node("../")
		character.kill()

func _ready():
	area.connect("area_entered", self, "collide")
