extends Actor
class_name Breakable

export var tiles_using := Vector2(1, 1)

onready var area = $Area2D
onready var area_collision = $Area2D/CollisionShape2D
onready var editor_area = $EditorArea
onready var editor_collision = $EditorArea/CollisionShape2D

onready var sprite = $Sprite
onready var particles = $BreakParticles

var type = "Breakable"

var particle_time_left = 0.0
var delete_time = 0.0

func set_properties():
	editable_properties = ["position"]

func collide(col_area):
	if col_area.name == "CharArea" and mode == 0:
		sprite.visible = false
		col_area.get_parent().play_break_anim()
		delete_time = 3.0
		particle_time_left = 0.25
		particles.emitting = true

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

func _physics_process(delta):
	if delete_time > 0:
		delete_time -= delta
		if delete_time <= 0:
			queue_free()
	if particle_time_left > 0:
		particle_time_left -= delta
		if particle_time_left <= 0:
			particles.emitting = false
