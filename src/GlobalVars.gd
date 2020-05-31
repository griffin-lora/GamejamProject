extends Node

var checkpoint_id := 0
var level_id := 0
var level_data := LevelData.new()

# RECHARGE TIME
var ability_recharge_time : float = 5

# Internal
var ability_recharge_ct : float = 0

func _ready():
	ability_recharge_ct = ability_recharge_time
	
func _process(delta):
	ability_recharge_ct = ability_recharge_ct + delta
	if ability_recharge_ct >= ability_recharge_time and Input.is_action_just_pressed("use_ability"):
		activate_ability()

func reset():
	checkpoint_id = 0

func switch_level():
	reset()
	var level_list = load("res://level_list.tres")
	var level_name = level_list.levels[level_id]
	get_tree().change_scene("res://levels/" + level_name + ".tscn")

func activate_ability():
	if get_tree().get_current_scene().mode == 0:
		ability_recharge_ct = 0
		print("ABILITY ACTIVATED")
