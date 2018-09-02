extends Node

func _ready():
	pass

func change_scene(scene : String) -> void:
	get_tree().change_scene(scene)
