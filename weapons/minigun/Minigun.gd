extends Sprite

var firing : bool = false

export (int) var damage = 3
export (float) var max_fire_rate = 10
export (float) var fire_rate_acceleration = 5
export (float) var spread_range = .01
export (float) var casing_spread_range = .5
var current_fire_rate : float = 0
var time_since_last_fire : float = 0

onready var animation_player : AnimationPlayer = $MinigunPlayer
onready var bullet_source : Node = $BulletSource
onready var heat_particles : CPUParticles2D = $HeatParticles
onready var casing_source : Node = $CasingSource
onready var spinup_audio : AudioStreamPlayer = $SpinupPlayer
onready var gunshot_audio : AudioStreamPlayer = $GunshotPlayer
onready var latch_audio : AudioStreamPlayer = $LatchPlayer

export (String) var bullet_path
var bullet_prefab

export (String) var casing_path
var casing_prefab

func _ready():
	bullet_prefab = load(bullet_path)
	casing_prefab = load(casing_path)

func _process(delta):
	if firing:
		current_fire_rate += fire_rate_acceleration*delta
		current_fire_rate = min(current_fire_rate, max_fire_rate)
		animation_player.play("Fire")
		time_since_last_fire += delta
		if time_since_last_fire > 1/current_fire_rate:
			# fire projectile
			fire_bullet()
			time_since_last_fire = 0
	else:
		current_fire_rate -= fire_rate_acceleration*delta
		current_fire_rate = min(max(current_fire_rate, 0), max_fire_rate)
	animation_player.playback_speed = current_fire_rate
	# emit weapon smoke
	if current_fire_rate == max_fire_rate:
		heat_particles.emitting = true
	else:
		heat_particles.emitting = false
	# play spinup audio
	if current_fire_rate > 0:
		if spinup_audio.playing == false:
			spinup_audio.playing = true
		spinup_audio.pitch_scale = (current_fire_rate/max_fire_rate)*.2+.8
	else:
		if spinup_audio.playing == true:
			spinup_audio.playing = false
			latch_audio.playing = true
	
func fire_bullet():
	# spawn the bullet
	var bullet = bullet_prefab.instance()
	get_tree().get_root().add_child(bullet)
	bullet.position = bullet_source.global_position
	var spread = (randf()*2-1)*spread_range*current_fire_rate
	if scale.y == -1: # hack to invert the rotation of a flipped weapon
		bullet.rotation = 6.28 - bullet_source.global_transform.get_rotation()+spread
	else:
		bullet.rotation = bullet_source.global_transform.get_rotation()+spread
	bullet.damage = damage
	bullet.projectile_ready()

	# spawn the casing
	var casing = casing_prefab.instance()
	get_tree().get_root().add_child(casing)
	casing.position = casing_source.global_position
	spread = (randf()*2-1)*casing_spread_range
	if scale.y == -1: # hack to invert the rotation of a flipped weapon
		casing.rotation = 3.14 - casing_source.global_transform.get_rotation()+spread
		casing.scale = Vector2(-1, -1)
	else:
		casing.rotation = casing_source.global_transform.get_rotation()+spread
	casing.projectile_ready()
	
	# play audio
	gunshot_audio.playing = true
	
