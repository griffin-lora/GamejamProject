extends AudioStreamPlayer

export var play_music : AudioStream
export var underground_music : AudioStream
export var edit_music : AudioStream
export var win_music : AudioStream

var last_mode := -1
var last_won := false

func _process(delta):
	OS.set_window_title("Torpedo Ted (FPS: " + str(int(Engine.get_frames_per_second())) + ")")
	var scene = get_tree().get_current_scene()
	var mode = scene.mode
	if mode != last_mode:
		if mode == 0:
			if GlobalVars.level_data.theme == 1:
				stream = underground_music
			else:
				stream = play_music
			play()
		else:
			stream = edit_music
			play()
			
	if mode == 0:
		var won = scene.won
		if won and !last_won:
			stream = win_music
			play()
		last_won = won
	last_mode = mode
