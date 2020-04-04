extends Sprite

var firing : bool = false

export (float) var starting_fire_rate = 1
export (float) var max_fire_rate = 10
export (float) var fire_rate_acceleration = 5
export (float) var spread_range = .01
var current_fire_rate : float = starting_fire_rate
var time_since_last_fire : float = 0

export (NodePath) var animation_player_path
var animation_player

export (NodePath) var bullet_source_path
var bullet_source

export (String) var bullet_path
var bullet_prefab

export (NodePath) var heat_particles_path
var heat_particles

func _ready():
	animation_player = get_node(animation_player_path)
	bullet_source = get_node(bullet_source_path)
	bullet_prefab = load(bullet_path)
	heat_particles = get_node(heat_particles_path)

func _process(delta):
	if firing:
		current_fire_rate += fire_rate_acceleration*delta
		current_fire_rate = min(max(current_fire_rate, starting_fire_rate), max_fire_rate)
		animation_player.play("Fire")
		time_since_last_fire += delta
		if time_since_last_fire > 1/current_fire_rate:
			fire_bullet()
			time_since_last_fire = 0
	else:
		current_fire_rate -= fire_rate_acceleration*delta
		current_fire_rate = min(max(current_fire_rate, 0), max_fire_rate)
		# animation_player.play("Idle")
		time_since_last_fire = 0
	animation_player.playback_speed = current_fire_rate

	if current_fire_rate == max_fire_rate:
		heat_particles.emitting = true
	else:
		heat_particles.emitting = false
	
func fire_bullet():
	var bullet = bullet_prefab.instance()
	get_tree().get_root().add_child(bullet)
	bullet.position = bullet_source.global_position
	var spread = (randf()*2-1)*spread_range*current_fire_rate
	if scale.y == -1: # hack to invert the rotation of a flipped weapon
		bullet.rotation = 6.28 - bullet_source.global_transform.get_rotation()+spread
	else:
		bullet.rotation = bullet_source.global_transform.get_rotation()+spread
	bullet.scale = Vector2(1,1)
	bullet.projectile_ready()
	
