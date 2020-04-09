extends KinematicBody2D

export (int) var initial_hp = 10
export (float) var walk_speed = 10
export (float) var alert_radius = 500

var alerted : bool = false
var hp : int = initial_hp

var player # player reference

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	if alerted:
		# walk towards player
		pass
	else:
		if player.position.distance_to(position) < alert_radius:
			print("Alerted!")
			alerted = true
