extends KinematicBody2D

export (int) var initial_hp = 10
export (float) var walk_speed = 200
export (float) var alert_radius = 500

var alerted : bool = false
onready var hp : int = initial_hp

var state : int = 0
# 0 = idle
# 1 = pursuing
# 2 = attacking

var path_to_player : = PoolVector2Array()
export (float) var path_update_period = 1
var path_age : float = path_update_period

var player : KinematicBody2D

onready var nav : Navigation2D = get_parent().get_node("Level/Navigation2D")

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	if alerted:
		# walk towards player
		if state == 1:
			path_age += delta
			if path_age > path_update_period:
				path_to_player = nav.get_simple_path(position, player.position, false)
				path_age = 0
			if path_to_player.size() > 0:
				var d: float = position.distance_to(path_to_player[0])
				if d > 10:
					position = position.linear_interpolate(path_to_player[0], (walk_speed * delta)/d)
					look_at(path_to_player[0])
				else:
					path_to_player.remove(0)
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
