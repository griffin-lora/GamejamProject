extends AnimatedSprite

var character
var angle = 0 # or theta as some dumbass fucking nerds call it

func _process(delta):
	angle += 0.1
	var v = Vector2(cos(angle), sin(angle))
	
