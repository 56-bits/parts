extends Node2D

export var is_active : bool = true
export var speed : float = 20

func _ready():
	pass

func _process(delta):
	if is_active:
		var follower = $Path2D/PathFollow2D
		follower.offset += speed * delta

func get_state():
	var state = {}
	state["pos"] = position
	state["offset"] = $Path2D/PathFollow2D.offset
	state["name"] = name
	return state

func set_state(state):
	position = state["pos"]
	$Path2D/PathFollow2D.offset = state["offset"]