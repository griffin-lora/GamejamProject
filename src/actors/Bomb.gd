extends Actor

onready var area = $Area2D

var character
var angle = 0 # or theta as some dumbass fucking nerds call it

var type = "Bomb"

# ITS NOT SHOWING UP AND THIS IS SOME HOT FUCKING BULLSHIT RIGHT OFF THE FUCKING GRILL

func _process(delta):
	if character:
		angle += 0.1
		var v = Vector2(cos(angle), sin(angle))
	#	print(position, character.position)
		position = character.position + (v * 2)

func play_break_anim():
	if character:
		character.play_break_anim()


func play_kill_sound():
	if character:
		character.play_kill_sound()
