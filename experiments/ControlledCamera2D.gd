extends Camera2D

class_name ControlledCamera2D

export var speed : int = 1000
export var zoom_rate : float = 1.1

func _process(delta):
	if Input.is_key_pressed(KEY_D):
		position.x += speed * delta
	if Input.is_key_pressed(KEY_A):
		position.x -= speed * delta
	if Input.is_key_pressed(KEY_W):
		position.y -= speed * delta
	if Input.is_key_pressed(KEY_S):
		position.y += speed * delta
	
	if Input.is_key_pressed(KEY_E):
		zoom *= zoom_rate
	if Input.is_key_pressed(KEY_Q):
		zoom /= zoom_rate
	
