extends RigidBody2D

export (float) var initial_force = 1000

var damage : int = 5

func projectile_ready():
	apply_central_impulse(global_transform.x*initial_force)
	
func _on_Bullet_body_entered(body):
	if body.is_in_group("Enemy"):
		print("Dealt " + String(damage) + " damage")
		body.damage(damage, "pierce")
	queue_free()
