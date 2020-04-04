extends Sprite

export (NodePath) var anim_path
var anim

export (float) var lifetime = 10

func projectile_ready():
	anim = get_node(anim_path)
	anim.play("Casing")
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()

