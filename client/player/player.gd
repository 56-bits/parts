extends Node

var movement = Vector2()
var sprint = false

var last_pos = position
var position setget set_pos, get_pos

func _ready():
	$character/Name.text = $"/root/globals".settings.player_name

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

func _network_tick():
	
	if get_pos() != last_pos:
		rpc("update_movement", get_pos(), movement, sprint)
		last_pos = get_pos()

func set_pos(pos):
	$character.position = pos

func get_pos():
	return $character.position