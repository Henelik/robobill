extends KinematicBody2D

export (float) var speed = 500
export (float) var max_bounce_degrees = 120
export (float) var min_bounce_degrees = 90

var damage : int = 5
var velocity : Vector2
onready var max_bounce_angle : float = deg2rad(max_bounce_degrees)
onready var min_bounce_angle : float = deg2rad(min_bounce_degrees)

func projectile_ready():
	velocity = global_transform.x * speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var angle = velocity.angle_to(collision.normal)
		if angle > min_bounce_angle and angle < max_bounce_angle:
			var reflect = collision.remainder.bounce(collision.normal)
			velocity = velocity.bounce(collision.normal)
			rotation = velocity.angle()
			move_and_collide(reflect)
		else:
			_on_hit(collision.collider)

func _on_hit(body):
	if body.is_in_group("Enemy"):
		print("Dealt " + String(damage) + " damage")
		body.damage(damage, "pierce")
	queue_free()
