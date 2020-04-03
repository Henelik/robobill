extends Sprite

var firing : bool = false

export (float) var starting_fire_rate = 1
export (float) var max_fire_rate = 10
export (float) var fire_rate_acceleration = 5
var current_fire_rate : float = starting_fire_rate
var time_since_last_fire : float = 0

export (NodePath) var animation_player_path
var animation_player

func _ready():
	animation_player = get_node(animation_player_path)

func _process(delta):
	if firing:
		current_fire_rate += fire_rate_acceleration*delta
		current_fire_rate = min(max(current_fire_rate, starting_fire_rate), max_fire_rate)
		animation_player.play("Fire")
		time_since_last_fire += delta
	else:
		current_fire_rate -= fire_rate_acceleration*delta
		current_fire_rate = min(max(current_fire_rate, 0), max_fire_rate)
		# animation_player.play("Idle")
		time_since_last_fire = 0
	animation_player.playback_speed = current_fire_rate
	
