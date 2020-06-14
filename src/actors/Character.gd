extends Actor

var center_pos := Vector2()
var path_index = 1

export var objects : NodePath
onready var objects_node = get_node(objects)

export var level : NodePath
onready var level_node = get_node(level)

onready var sprite = $Sprite
onready var arm = $Sprite/Arm
onready var rotation_setter = $HackyRotationSetter
onready var particles = $Particles
onready var bubbles = $Particles/Particles2D
onready var afterimage = $Particles/Afterimage
onready var explosion = $Explosion
onready var break_sound = $BreakSound
onready var explosion_sound = $ExplosionSound
onready var kill_sound = $KillSound
onready var rewind_sound = $RewindSound
onready var power_down_sound = $PowerDownSound
onready var power_up_sound = $PowerUpSound
onready var time_slow_sound = $TimeSlowSound
onready var path_node = get_node(path)
onready var actors = get_node("../")

export var reaction_speed = 12.5
export var fly_speed = 7.25
export var slow_fly_speed = 3.125
export var rotation_speed = 5.0
export var mouse_rotation_speed = 12.5
export var arm_speed = 7.5

export var path_interpolation_speed = 35.0
export var path : NodePath
var path_points
var target
var move_normal = Vector2()

var base_rotation = 0

var type = "Character"
var shake_time = 0.0
var reload_time = 0.0
var dead = false
var ready = false
var won = false
var is_sorta_dead = false
var to_rewind_ticker = 0
var is_rewinding = false
var to_done_with_this_bs_ticker = 0
var ted_lerp_back_to
var center_pos_lerp_back_to

var power_state = true
var is_powered_down = false
var down_ticker = 0
var up_ticker = 0
var mini_ticker = 0

var bombs = []
var has_bombs = false

var last_move_vector = Vector2()

func play_kill_sound():
	if !won:
		kill_sound.play()

func play_break_anim():
	if !won:
		break_sound.play()
		shake_time = 0.25
	
func win():
	if !won:
		won = true
		level_node.won = true
		GlobalVars.is_slow = false
		GlobalVars.slow_ticker = 0
		GlobalVars.pre_death_ability_recharge_ct = GlobalVars.ability_recharge_ct

func kill():
	if !dead and !won:
		if GlobalVars.ability_id == 2 and GlobalVars.ability_recharge_ct >= GlobalVars.ability_recharge_time:
			GlobalVars.ability_recharge_ct = 0
			# rewind poggers
			is_sorta_dead = true
			explosion.visible = true
			sprite.visible = false
			bubbles.emitting = false
			afterimage.emitting = false
			var f = 20
			ted_lerp_back_to = position - (last_move_vector * f)
			center_pos_lerp_back_to = center_pos - (last_move_vector *f)
			explosion_sound.play()
		else:
			GlobalVars.is_slow = false
			GlobalVars.slow_ticker = 0
			dead = true
			explosion.visible = true
			sprite.visible = false
			bubbles.emitting = false
			afterimage.emitting = false
			reload_time = 0.75
			explosion_sound.play()
			GlobalVars.score = clamp(GlobalVars.score - 5000, 0, INF)
			GlobalVars.pre_death_ability_recharge_ct += 3000

func _ready():
	GlobalVars.ability_recharge_ct = GlobalVars.pre_death_ability_recharge_ct
	yield(get_tree(), "physics_frame")
	if path:
		path_node.curve.set_bake_interval(fly_speed)
		path_points = path_node.curve.get_baked_points()
		path_node.curve.tessellate(5, 4)
		
	position = path_points[0] - Vector2(512, 0)
	
	if GlobalVars.checkpoint_id >= 1:
		for actor in actors.get_children():
			if actor.type == "Checkpoint" and actor.checkpoint_id == GlobalVars.checkpoint_id:
				path_index = actor.path_index
				position = path_points[path_index - 1]
	center_pos = position
	target = path_points[path_index]
	move_normal = (target - center_pos).normalized()
	ready = true
	
func angle_difference(angle1, angle2):
	var diff = angle2 - angle1
	return diff if abs(diff) < 180 else diff + (360 * -sign(diff))
		
func _physics_process(delta):
	if ready:
		if shake_time > 0:
			shake_time -= delta
			if shake_time <= 0:
				shake_time = 0
		if reload_time > 0:
			reload_time -= delta
			if reload_time <= 0:
				reload_time = 0
				get_tree().reload_current_scene()
				
		if won:
			for object in objects_node.get_children():
				var color = object.modulate
				color.a -= 0.05
				object.modulate = color
			if Input.is_action_just_pressed("continue"):
				if GlobalVars.is_editor_mode:
					for index in range(8):
						yield(get_tree(), "physics_frame")
					get_tree().change_scene("res://editor.tscn")
				else:
					GlobalVars.level_id += 1
					GlobalVars.switch_level(true)
					Music.update_music()
		
		if !dead and !is_sorta_dead:
			if center_pos.distance_to(target) < (fly_speed * 1.5) and path_index + 1 < path_points.size():
				path_index += 1
				target = path_points[path_index]
				move_normal = move_normal.linear_interpolate((target - center_pos).normalized(), delta * 27)
			elif path_index + 1 >= path_points.size():
				win()
				
			if path_index > 0:
				var last_target = path_points[path_index - 1]
				var dx = target.x - last_target.x
				var dy = target.y - last_target.y
				var x_normal = Vector2(-dy, dx)
				var y_normal = Vector2(dy, -dx)
				base_rotation = y_normal.angle() + PI/2
			
			var old_center_pos = Vector2(center_pos.x, center_pos.y) # probably wouldve worked the easier way but im worried about mutability at 3 am
				
			if !(GlobalVars.is_slow and GlobalVars.ability_id == 0):
				if abs(angle_difference(wrapf(rotation_degrees, -180, 180), rad2deg(base_rotation))) < 5:
					center_pos += move_normal * fly_speed
				else:
					center_pos += move_normal * (fly_speed/1.5)
			else:
				if abs(angle_difference(wrapf(rotation_degrees, -180, 180), rad2deg(base_rotation))) < 5:
					center_pos += move_normal * slow_fly_speed
				else:
					center_pos += move_normal * (slow_fly_speed/1.5)
				
			last_move_vector = center_pos - old_center_pos
				
			var mouse_pos = get_global_mouse_position()
			var mouse_screen_pos = get_viewport().get_mouse_position()
			position = position.linear_interpolate(mouse_pos, delta * reaction_speed)
			rotation_setter.offset = rotation_setter.offset.linear_interpolate(mouse_screen_pos, delta * reaction_speed)
			
			var move_angle = 0
			rotation_setter.rotation_degrees = lerp(rotation_setter.rotation_degrees, clamp(mouse_screen_pos.y - rotation_setter.offset.y, -35, 35), delta * mouse_rotation_speed)
			move_angle = rotation_setter.rotation
			if GlobalVars.is_slow and GlobalVars.ability_id == 0:
				move_angle = 0
				afterimage.emitting = true
				afterimage.process_material.set("angle", -rotation_degrees)
			else:
				afterimage.emitting = false
			
			sprite.rotation = lerp_angle(sprite.rotation, move_angle, delta * mouse_rotation_speed)
			particles.rotation = sprite.rotation
			rotation = lerp_angle(rotation, base_rotation, delta * rotation_speed)
		
			if mouse_screen_pos.y - rotation_setter.offset.y < 5 or (GlobalVars.is_slow and GlobalVars.ability_id == 0):
				arm.rotation = lerp_angle(arm.rotation, 0, delta * arm_speed)
				arm.position = arm.position.linear_interpolate(Vector2(), delta * arm_speed)
			else:
				arm.rotation = lerp_angle(arm.rotation, PI/2, delta * arm_speed)
				arm.position = arm.position.linear_interpolate(Vector2(0, -2), delta * arm_speed)
		else:
			if is_rewinding:
				if to_done_with_this_bs_ticker == 0:
					explosion.visible = false
					sprite.visible = true
					bubbles.emitting = true
					rewind_sound.play()
				sprite.rotation = 0
				particles.rotation = 0
				rotation = base_rotation
				position = lerp(position, ted_lerp_back_to, delta * 4)
				center_pos = lerp(center_pos, center_pos_lerp_back_to, delta * 4)
				to_done_with_this_bs_ticker += delta
				if to_done_with_this_bs_ticker >= 1:
					to_done_with_this_bs_ticker = 0
					to_rewind_ticker = 0
					is_rewinding = false
					is_sorta_dead = false
			elif is_sorta_dead:
				to_rewind_ticker += delta
				if to_rewind_ticker >= 1:
					is_rewinding = true
		
		if GlobalVars.ability_id != 2 and GlobalVars.ability_recharge_ct >= GlobalVars.ability_recharge_time and Input.is_action_just_pressed("use_ability") and !dead and !won:
			GlobalVars.activate_ability()
			if GlobalVars.ability_id == 0:
				time_slow_sound.play()
		
		if GlobalVars.is_slow and GlobalVars.ability_id == 1 and not has_bombs:
			has_bombs = true
			var bomb = load("res://actors/bomb.tscn").instance()
			bomb.character = self
			print("CREATE")
			bombs.append(bomb)
			add_child(bomb)
		
		if GlobalVars.ability_id == 3:
			if GlobalVars.is_slow:
				if down_ticker == 0:
					is_powered_down = true
					power_down_sound.play()
				down_ticker += delta
				mini_ticker += delta
				if power_state:
					scale = Vector2(0.333,0.333)
				else:
					scale = Vector2(1, 1)
				if mini_ticker >= 0.075:
					mini_ticker = 0
					power_state = !power_state
				if down_ticker >= 0.75:
					scale = Vector2(0.333,0.333)
			elif is_powered_down:
				if up_ticker == 0:
					mini_ticker = 0
					power_up_sound.play()
				up_ticker += delta
				mini_ticker += delta
				if power_state:
					scale = Vector2(0.333,0.333)
				else:
					scale = Vector2(1, 1)
				if mini_ticker >= 0.075:
					mini_ticker = 0
					power_state = !power_state
				if up_ticker >= 0.75:
					scale = Vector2(1, 1)
					is_powered_down = false
					down_ticker = 0
					up_ticker = 0
					mini_ticker = 0
					power_state = true
	
func _input(event):
	if event.is_action_pressed("reset"):
		kill()
