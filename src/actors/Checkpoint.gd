extends Actor

onready var area = $Area2D
export var tiles_using := Vector2(1, 1)

export var checkpoint_id := 1
export var path_index := 1
onready var editor_area = $Area2D
onready var editor_collision = $Area2D/CollisionShape2D

var type = "Checkpoint"

func collide(col_area):
	if col_area.name == "CharArea":
		GlobalVars.checkpoint_id = checkpoint_id

func set_properties():
	editable_properties = ["position", "checkpoint_id"]

func _ready():
	id = 6
	area.connect("area_entered", self, "collide")

func intersects_pos(test_position):
	var min_pos = position
	var max_pos = min_pos + (editor_collision.shape.extents * 2)
	
	if (test_position.x >= min_pos.x 
	and test_position.y >= min_pos.y 
	and test_position.x < max_pos.x 
	and test_position.y < max_pos.y):
		return true
	else:
		return false
