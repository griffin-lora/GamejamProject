extends Actor
class_name Obstacle

onready var area = $Area2D
onready var area_collision = $Area2D/CollisionShape2D
onready var editor_area = $EditorArea
onready var editor_collision = $EditorArea/CollisionShape2D

onready var top_part = $Top
onready var middle_part = $Middle
onready var bottom_part = $Bottom

var type = "Obstacle"

func collide(col_area):
	if col_area.name == "CharArea" and mode == 0:
		var character = col_area.get_node("../")
		character.kill()

func _ready():
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
