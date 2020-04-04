extends RigidBody2D

export (float) var initial_force = 1000

func projectile_ready():
	apply_central_impulse(global_transform.x*initial_force)
	
func _on_Bullet_body_entered(body):
	queue_free()
