extends Actor
class_name Enemy

export var tiles_using := Vector2(1, 1)

onready var body = $KinematicBody2D
onready var area = $KinematicBody2D/Area
onready var editor_area = $KinematicBody2D/EditorArea
onready var editor_collision = $KinematicBody2D/EditorArea/CollisionShape2D

onready var sprite = $KinematicBody2D/Sprite

var type = "Enemy"

var delete_time = 0.0
var time_alive = 0.0

var original_pos : Vector2
var velocity := Vector2()

export var underground_frames : SpriteFrames
export var snow_frames : SpriteFrames
export var ghost_frames : SpriteFrames

func set_properties():
	editable_properties = ["position"]

func collide(col_area):
	if (col_area.name == "CharArea" or col_area.name == "BombArea") and mode == 0 and delete_time == 0:
		col_area.get_parent().play_kill_sound()
		delete_time = 3.0
		velocity.x = -10
		velocity.y = -90
		sprite.flip_v = true
		GlobalVars.score += 600
		GlobalVars.ability_recharge_ct += 600
		
func _ready():
	original_pos = position
	area.connect("area_entered", self, "collide")
	if GlobalVars.level_data.theme == 1:
		sprite.frames = underground_frames
	elif GlobalVars.level_data.theme == 2:
		sprite.frames = snow_frames
	elif GlobalVars.level_data.theme == 3:
		sprite.frames = ghost_frames
	elif GlobalVars.level_data.theme == 4:
		sprite.frames = ghost_frames

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

func _physics_process(delta):
	if mode == 0:
		if delete_time == 0:
			time_alive += delta
			position.y = original_pos.y + (sin(time_alive * 3) * 8)
			position.x -= 0.25
		else:
			velocity.y += 7
			position += velocity * delta
	
	if delete_time > 0:
		delete_time -= delta
		if delete_time <= 0:
			queue_free()
