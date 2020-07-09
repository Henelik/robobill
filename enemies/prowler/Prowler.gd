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
export (float) var path_update_period = .5
var path_age : float = path_update_period

var player : KinematicBody2D

onready var nav : Navigation2D = get_parent().get_node("Level/Navigation2D")

var velocity : Vector2 = Vector2(0, 0)
var acceleration : float = .2

export (String) var blood_splat_path
onready var blood_splat_prefab = load(blood_splat_path)

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	if alerted:
		if state == 1: # walk towards player
			$Body/AnimationPlayer.play("Walk")
			path_age += delta
			if path_age > path_update_period:
				path_to_player = nav.get_simple_path(position, player.position, false)
				path_age = 0
			if path_to_player.size() > 1:
				var d: float = position.distance_to(path_to_player[0])
				if d > 10:
					# position = position.linear_interpolate(path_to_player[0], (walk_speed * delta)/d)
					var ideal_velocity = position.direction_to(path_to_player[0]).normalized()*walk_speed
					# print_debug(ideal_velocity)
					velocity = velocity.linear_interpolate(ideal_velocity, acceleration)
				else:
					path_to_player.remove(0)
			else:
				velocity.linear_interpolate(Vector2(0, 0), acceleration)
		elif state == 2:
			pass
	else:
		$Body/AnimationPlayer.stop()
		if player.position.distance_to(position) < alert_radius:
			print("Alerted!")
			alerted = true
			state = 1

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	look_at(position+velocity)

func damage(amount, type, collision, direction): # collision may be null!
	if type == "pierce": # spawn a blood splat
		var splat = blood_splat_prefab.instance()
		get_tree().get_root().add_child(splat)
		if collision != null:
			splat.position = collision.position
			splat.rotation = direction.angle()
	
	# figure out if we should die
	if amount >= hp:
		die(amount-hp, type)
		return
	hp -= amount

func die(overkill, dmgType):
	queue_free()

func attack():
	pass
