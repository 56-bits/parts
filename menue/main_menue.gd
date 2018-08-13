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
	
	var global = $"/root/globals"
	global.settings.player_name = $ViewportContainer/VBoxContainer_settings/name_section/LineEdit.text
	global.settings.server_ip = $ViewportContainer/VBoxContainer_settings/ip_section/LineEdit.text
	global.settings.port = $ViewportContainer/VBoxContainer_settings/port_section/SpinBox.value
	global.settings.player_limit = $ViewportContainer/VBoxContainer_settings/player_limit_section/SpinBox.value

func _on_LineEdit_ip_text_entered(new_text):
	var feedback = $"/root/globals".feedback
	if new_text.is_valid_ip_address():
		feedback.new_message("IP adress is valid", "good")
	else:
		feedback.new_message("IP adress is invalid", "bad")
