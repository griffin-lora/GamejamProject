extends Node

var checkpoint_id := 0
var level_id := 0
var level_data := LevelData.new()
var score := 0
var is_editor_mode = false

# RECHARGE TIME
var ability_recharge_time : float = 5

# Internal
var ability_recharge_ct : float = 0

var ability_id := 0

var is_slow := false
var slow_time : float = 5
var slow_ticker : float = 0

var scene_cache = []

func _ready():
	var id_mapper = load("res://actors/obstacles/ids.tres")
	for id in id_mapper.ids:
		var object_resource = load("res://actors/obstacles/" + id + ".tres")
		var object_scene = load(object_resource.scene_path)
		scene_cache.append(object_scene)
		
	pause_mode = PAUSE_MODE_PROCESS
	ability_recharge_ct = ability_recharge_time
	switch_level()
	
func _process(delta):
	if get_tree().get_current_scene().mode == 0:
		ability_recharge_ct = ability_recharge_ct + delta
	if ability_recharge_ct >= ability_recharge_time and Input.is_action_just_pressed("use_ability"):
		activate_ability()
	if Input.is_action_just_pressed("copy_level_data") and get_tree().get_current_scene().mode == 1:
		OS.clipboard = level_data.encode()
		
	if Input.is_action_just_pressed("paste_level_data") and get_tree().get_current_scene().mode == 1:
		level_data.decode(OS.clipboard)
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("pause") and get_tree().get_current_scene().mode == 0:
		get_tree().paused = !get_tree().paused
		
	if is_slow:
		slow_ticker += delta
		if slow_ticker >= slow_time:
			is_slow = false

func reset():
	checkpoint_id = 0

func switch_level():
	var level_list = load("res://level_list.tres")
	var level_name = level_list.levels[level_id]
	var level_contents = load("res://assets/levels/" + level_name + ".tres")
	level_data.decode(level_contents.data)
	get_tree().reload_current_scene()

func activate_ability():
	if get_tree().get_current_scene().mode == 0 and false:
		ability_recharge_ct = 0
		print("ability activate")
		if ability_id == 0: #goodcode
			time_slow()

func time_slow():
	slow_ticker = 0
	is_slow = true
