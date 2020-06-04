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
onready var path_node = get_node(path)
onready var actors = get_node("../")

export var reaction_speed = 12.5
export var fly_speed = 6.25
export var slow_fly_speed = 3.125
export var rotation_speed = 7.5
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

func kill():
	if !dead and !won:
		dead = true
		explosion.visible = true
		sprite.visible = false
		bubbles.emitting = false
		afterimage.emitting = false
		reload_time = 0.75
		explosion_sound.play()

func _ready():
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
		
		if !dead:
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
				
			if !GlobalVars.is_slow:
				center_pos += move_normal * fly_speed
			else:
				center_pos += move_normal * slow_fly_speed
				
			var mouse_pos = get_global_mouse_position()
			var mouse_screen_pos = get_viewport().get_mouse_position()
			position = position.linear_interpolate(mouse_pos, delta * reaction_speed)
			rotation_setter.offset = rotation_setter.offset.linear_interpolate(mouse_screen_pos, delta * reaction_speed)
			
			var move_angle = 0
			rotation_setter.rotation_degrees = lerp(rotation_setter.rotation_degrees, clamp(mouse_screen_pos.y - rotation_setter.offset.y, -35, 35), delta * mouse_rotation_speed)
			move_angle = rotation_setter.rotation
			if GlobalVars.is_slow:
				move_angle = 0
				afterimage.emitting = true
			else:
				afterimage.emitting = false
			
			sprite.rotation = lerp_angle(sprite.rotation, move_angle, delta * mouse_rotation_speed)
			particles.rotation = sprite.rotation
			rotation = lerp_angle(rotation, base_rotation, delta * rotation_speed)
		
			if mouse_screen_pos.y - rotation_setter.offset.y < 5 or GlobalVars.is_slow:
				arm.rotation = lerp_angle(arm.rotation, 0, delta * arm_speed)
				arm.position = arm.position.linear_interpolate(Vector2(), delta * arm_speed)
			else:
				arm.rotation = lerp_angle(arm.rotation, PI/2, delta * arm_speed)
				arm.position = arm.position.linear_interpolate(Vector2(0, -2), delta * arm_speed)
	
func _input(event):
	if event.is_action_pressed("reset"):
		kill()
