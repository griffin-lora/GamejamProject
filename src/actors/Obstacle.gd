extends Actor
class_name Obstacle

onready var area = $Area2D
onready var area_collision = $Area2D/CollisionShape2D
onready var editor_area = $EditorArea
onready var editor_collision = $EditorArea/CollisionShape2D

onready var top_part = $Top
onready var middle_part = $Middle
onready var bottom_part = $Bottom

export var underground_top : StreamTexture
export var underground_body : StreamTexture

export var snow_top : StreamTexture
export var snow_body : StreamTexture

export var ghost_top : StreamTexture
export var ghost_body : StreamTexture

export var castle_top : StreamTexture
export var castle_body : StreamTexture

export var sky_top : StreamTexture
export var sky_body : StreamTexture

var type = "Obstacle"

func collide(col_area):
	if col_area.name == "CharArea" and mode == 0:
		var character = col_area.get_node("../")
		if !character.is_sorta_dead:
			character.kill()

func _ready():
	area.connect("area_entered", self, "collide")
	if GlobalVars.level_data.theme == 1:
		top_part.texture = underground_top
		middle_part.texture = underground_body
		bottom_part.texture = underground_top
		bottom_part.flip_v = true
	elif GlobalVars.level_data.theme == 2:
		top_part.texture = snow_top
		middle_part.texture = snow_body
		bottom_part.texture = snow_top
		bottom_part.flip_v = true
	elif GlobalVars.level_data.theme == 3:
		top_part.texture = ghost_top
		middle_part.texture = ghost_body
		bottom_part.texture = ghost_top
		bottom_part.flip_v = true
	elif GlobalVars.level_data.theme == 4:
		top_part.texture = castle_top
		middle_part.texture = castle_body
		bottom_part.texture = castle_top
		bottom_part.flip_v = true
	elif GlobalVars.level_data.theme == 5:
		top_part.texture = sky_top
		middle_part.texture = sky_body
		bottom_part.texture = sky_top
		bottom_part.flip_v = true

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
