extends Actor

export var level_id := 0

onready var area = $Area2D

var type = "Goal"

func collide(col_area):
	if col_area.name == "CharArea":
		GlobalVars.level_id = level_id
		GlobalVars.switch_level()

func _ready():
	area.connect("area_entered", self, "collide")
