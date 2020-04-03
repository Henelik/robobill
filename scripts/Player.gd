extends KinematicBody2D

export (int) var max_speed = 200
export (NodePath) var body_path
export (NodePath) var light_path
var body
var light

export (int) var light_cooldown = 10
var _light_toggle_time = 0

var velocity = Vector2()
var mouse_pos

export (NodePath) var legs_path
export (NodePath) var legs_player_path
var legs_rotation_speed = .5
var legs
var legs_player

export (NodePath) var left_weapon_player_path
export (NodePath) var right_weapon_player_path
var left_weapon_player
var right_weapon_player

var walking

func _ready():
	body = get_node(body_path)
	light = get_node(light_path)
	legs = get_node(legs_path)
	legs_player = get_node(legs_player_path)
	left_weapon_player = get_node(left_weapon_player_path)
	right_weapon_player = get_node(right_weapon_player_path)

func get_input():
	velocity = Vector2()
	_light_toggle_time -= 1
	walking = false
	if Input.is_action_pressed('right'):
		velocity.x += 1
		walking = true
	if Input.is_action_pressed('left'):
		velocity.x -= 1
		walking = true
	if Input.is_action_pressed('down'):
		velocity.y += 1
		walking = true
	if Input.is_action_pressed('up'):
		velocity.y -= 1
		walking = true
	if Input.is_action_pressed('light'):
		toggle_light()
	if Input.is_action_pressed('primary_fire'):
		left_weapon_player.play("Fire")
		right_weapon_player.play("Fire")
	else:
		left_weapon_player.play("Idle")
		right_weapon_player.play("Idle")
	if velocity.x != 0 || velocity.y != 0:
		legs_player.play("Walking")
	else:
		legs_player.play("Idle")
	if walking:
		velocity = velocity.normalized() * max_speed
		legs.rotation = velocity.angle()*legs_rotation_speed + legs.rotation*(1-legs_rotation_speed)
	
func toggle_light():
	if _light_toggle_time <= 0:
		_light_toggle_time = light_cooldown
		light.visible = !light.visible

func _physics_process(delta):
	# move the character
	get_input()
	velocity = move_and_slide(velocity)
	
	# rotate the body towards the mouse
	mouse_pos = get_local_mouse_position()
	body.rotation = mouse_pos.angle()