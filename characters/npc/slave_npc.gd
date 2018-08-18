extends Node

var movement = Vector2()
var sprint = false

func _ready():

	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

slave func update_movement(pos, mov, spr):
	$character.position = pos
	movement = mov
	sprint = spr

slave func update_status():
	pass