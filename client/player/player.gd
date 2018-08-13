extends Node2D

func _ready():
	$Name.text = $"/root/globals".settings.player_name

func _input(event):
	pass
	

func _process(delta):
	var movement = Vector2(0,0)
	
	if Input.is_action_pressed("move_right"):
		movement.x += 1
	if Input.is_action_pressed("move_left"):
		movement.x -= 1
	if Input.is_action_pressed("move_up"):
		movement.y -= 1
	if Input.is_action_pressed("move_down"):
		movement.y += 1
	
	var sprint = Input.is_action_pressed("fast_modifier")
	
	$character.rpc_unreliable("move", movement, sprint)

func _draw():
	if is_network_master():
		draw_rect(Rect2(-Vector2(18, 34), Vector2(34, 68)), Color(1, 0, 0, 0.5), false)

func _network_tick():
	pass
#	rpc("update_movement", movement, position)
