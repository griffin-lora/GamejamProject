extends Node

var checkpoint_id := 0
var level_id := 0

func reset():
	checkpoint_id = 0

func switch_level():
	reset()
	var level_list = load("res://level_list.tres")
	var level_name = level_list.levels[level_id]
	get_tree().change_scene("res://levels/" + level_name + ".tscn")
