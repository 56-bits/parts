extends Node

var menue_id = 0

func _ready():
	pass

func _process(delta):
	#menue naviagation
	match menue_id:
		0 :
			$ViewportContainer/VBoxContainer_main.show()
			$ViewportContainer/VBoxContainer_settings.hide()
		1 :
			$ViewportContainer/VBoxContainer_main.hide()
			$ViewportContainer/VBoxContainer_settings.show()
		_ :
			menue_id = 0

#button actions

func _on_ToolButton_server_pressed():
	get_tree().change_scene("res://server/server.tscn")


func _on_ToolButton_client_pressed():
	get_tree().change_scene("res://client/client.tscn")


func _on_ToolButton_settings_pressed():
	menue_id = 1

func _on_ToolButton_backSettings_pressed():
	menue_id = 0
