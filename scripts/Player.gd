extends KinematicBody2D

export (int) var speed = 200
export (NodePath) var body_path
export (NodePath) var light_path
var body
var light

export (int) var light_cooldown = 10
var _light_toggle_time = 0

var velocity = Vector2()
var mouse_pos

func _ready():
	body = get_node(body_path)
	light = get_node(light_path)
	

func get_input():
	velocity = Vector2()
	_light_toggle_time -= 1
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	if Input.is_action_pressed('light'):
		toggle_light()
	velocity = velocity.normalized() * speed
	
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