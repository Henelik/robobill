extends Node2D

export(Array, Texture) var textures

func _ready():
	$Sprite/AnimationPlayer.play("splat")
	scale.y = pow(-1, randi() % 2) # random 1 or -1 y scale
	$Sprite.texture = textures[randi() % textures.size()] # random texture from the array
	$BloodSmoke.emitting = true
	$Squib.emitting = true
