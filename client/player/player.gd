extends Node2D

var movement = Vector2()
var sprint = false

onready var last_pos = position

func _ready():
	$Name.text = $"/root/globals".settings.player_name

func _process(delta):
	movement = Vector2()
	
	if Input.is_action_pressed("move_right"):
		movement.x += 1
	if Input.is_action_pressed("move_left"):
		movement.x -= 1
	if Input.is_action_pressed("move_up"):
		movement.y -= 1
	if Input.is_action_pressed("move_down"):
		movement.y += 1
	
	sprint = Input.is_action_pressed("fast_modifier")
	
	$character.move(movement, sprint)

func _draw():
	if is_network_master():
		draw_rect(Rect2(-Vector2(18, 34), Vector2(34, 68)), Color(1, 0, 0, 0.5), false)

func _network_tick():
	if position != last_pos:
		rpc("update_movement", position, movement, sprint)
		last_pos = position
	
