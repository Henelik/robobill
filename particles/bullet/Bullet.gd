extends KinematicBody2D

export (float) var speed = 1000
export (float) var max_bounce_degrees = 130
export (float) var min_bounce_degrees = 90
export (float) var lifetime = 5.0

var damage : int = 5
var velocity : Vector2
var time_alive : float = 0.0
onready var max_bounce_angle : float = deg2rad(max_bounce_degrees)
onready var min_bounce_angle : float = deg2rad(min_bounce_degrees)

func projectile_ready():
	velocity = global_transform.x * speed

func _physics_process(delta):
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.collider
		if body.is_in_group("Enemy") or body.is_in_group("Player"):
			_on_hit(body, collision)
			return
		var angle = abs(velocity.angle_to(collision.normal))
		if angle > min_bounce_angle and angle < max_bounce_angle:
			var reflect = collision.remainder.bounce(collision.normal)
			velocity = velocity.bounce(collision.normal)
			rotation = velocity.angle()
			move_and_collide(reflect)
		else:
			_on_hit(body, collision)

func _on_hit(body, collision):
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		print("Dealt " + String(damage) + " damage")
		body.damage(damage, "pierce", collision, velocity.normalized())
	queue_free()
