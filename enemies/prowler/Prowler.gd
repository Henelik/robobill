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

var player : KinematicBody2D

onready var nav : Navigation2D = get_parent().get_node("Level/Navigation2D")

onready var line : Line2D = get_parent().get_node("Line2D")

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	if alerted:
		# walk towards player
		if state == 1:
			path_to_player = nav.get_simple_path(position, player.position, false)
			line.points = PoolVector2Array(path_to_player)
			line.show()
			# state = 2
		elif state == 2:
			pass
	else:
		if player.position.distance_to(position) < alert_radius:
			print("Alerted!")
			alerted = true
			state = 1

func damage(amount, type):
	if amount >= hp:
		die(amount-hp, type)
		return
	hp -= amount

func die(overkill, dmgType):
	queue_free()

func attack():
	pass
