extends Node2D

class_name Controller2D

export var speed : int = 50

func _process(delta):
	if Input.is_key_pressed(KEY_D):
		position.x += speed * delta
	if Input.is_key_pressed(KEY_A):
		position.x -= speed * delta
	if Input.is_key_pressed(KEY_W):
		position.y -= speed * delta
	if Input.is_key_pressed(KEY_S):
		position.y += speed * delta