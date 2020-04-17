extends KinematicBody2D

export (int) var initial_hp = 10
export (float) var walk_speed = 10
export (float) var alert_radius = 500

var alerted : bool = false
onready var hp : int = initial_hp

var state : int = 0
# 0 = idle
# 1 = pursuing
# 2 = attacking

var path_to_player : = PoolVector2Array()

var player : KinematicBody2D# player reference

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	if alerted:
		# walk towards player
		if state == 1:
			pass
		elif state == 2:
			pass
	else:
		if player.position.distance_to(position) < alert_radius:
			print("Alerted!")
			alerted = true

func damage(amount, type):
	if amount >= hp:
		die(amount-hp, type)
		return
	hp -= amount

func die(overkill, dmgType):
	queue_free()

func attack():
	pass
