extends "res://characters/CharacterController.gd"

func _ready():
	._ready()
	$character/Name.text = $"/root/globals".settings.player_name
	$character.colour = $"/root/globals".settings.colour

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
