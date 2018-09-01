extends Node

var movement : Vector2 = Vector2()
var sprint : bool = false

export var position : Vector2 setget set_pos, get_pos
var last_pos : Vector2 = position

func _ready():
	if position != Vector2():
		self.position = position

func _network_tick():
	if self.position != last_pos:
		rpc("update_movement", self.position, movement, sprint)
		last_pos = self.position

func set_pos(pos : Vector2) -> void:
	$character.position = pos
	position = pos

func get_pos() -> Vector2:
	return $character.position