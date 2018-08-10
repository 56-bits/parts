extends Node2D

var speed = 100
var movement = Vector2(0,0)

func _ready():
	$Name.text = $"/root/globals".settings.player_name

func _input(event):
	pass
	

func _process(delta):
	movement = Vector2(0,0)
	
	if Input.is_action_pressed("move_right"):
		movement.x += 1
	if Input.is_action_pressed("move_left"):
		movement.x -= 1
	if Input.is_action_pressed("move_up"):
		movement.y -= 1
	if Input.is_action_pressed("move_down"):
		movement.y += 1
	
	position += movement * speed * delta

func _draw():
	if is_network_master():
		draw_rect(Rect2(-Vector2(34, 34), Vector2(68, 68)), Color(1, 0, 0), false)

func _network_tick():
	rpc("update_movement", movement, position)
