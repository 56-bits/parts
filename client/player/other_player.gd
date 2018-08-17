extends Node

var speed = 100
var movement = Vector2(0,0)
var sprint = false
var position = Vector2() setget set_pos, get_pos

var is_interpolating = false
var last_pos = Vector2(0,0)

func _ready():
	pass

func _process(delta):
	
	$character.move(movement, sprint)

slave func update_movement(pos, mov, spr):
	set_pos(pos)
	movement = mov
	sprint = spr

func set_pos(pos):
	$character.position = pos

func get_pos():
	return $character.position
