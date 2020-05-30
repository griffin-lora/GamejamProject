extends Actor

onready var area = $Area2D

export var checkpoint_id := 1

var type = "Checkpoint"

func collide(col_area):
	if col_area.name == "CharArea":
		GlobalVars.checkpoint_id = checkpoint_id

func _ready():
	area.connect("area_entered", self, "collide")
