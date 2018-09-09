extends Node

var menu_id : int = 0 setget menu_change
onready var global = $"/root/globals"
onready var feedback = globals.feedback

func _ready():
	randomize()
	
	$ViewportContainer/VBoxContainer_settings/name_section/LineEdit.text = global.settings.player_name 
	$ViewportContainer/VBoxContainer_settings/ip_section/LineEdit.text = global.settings.server_ip
	$ViewportContainer/VBoxContainer_settings/port_section/SpinBox.value = global.settings.port
	$ViewportContainer/VBoxContainer_settings/player_limit_section/SpinBox.value = global.settings.player_limit
	$ViewportContainer/VBoxContainer_settings/colour_section/ColorPickerButton.color = global.settings.colour

func menu_change(new_id):
	menu_id = new_id
	
	match menu_id:
		0 :
			$ViewportContainer/VBoxContainer_main.show()
			$ViewportContainer/VBoxContainer_settings.hide()
		1 :
			$ViewportContainer/VBoxContainer_main.hide()
			$ViewportContainer/VBoxContainer_settings.show()
		_ :
			menu_id = 0

#button actions

## main menuu
func _on_ToolButton_server_pressed():
	get_tree().change_scene("res://server/server.tscn")

func _on_ToolButton_client_pressed():
	get_tree().change_scene("res://client/client.tscn")

func _on_ToolButton_cinematic_pressed():
	get_tree().change_scene("res://cinematics/TestCinematic.tscn")

func _on_ToolButton_QuadTree_pressed():
	get_tree().change_scene("res://world/quadtree/qt.tscn")
	feedback.new_message("Press esc. to exit")

func _on_ToolButton_settings_pressed():
	self.menu_id = 1

## settings
func _on_ToolButton_backSettings_pressed():
	self.menu_id = 0
	
	global.settings.player_name = $ViewportContainer/VBoxContainer_settings/name_section/LineEdit.text
	global.settings.server_ip = $ViewportContainer/VBoxContainer_settings/ip_section/LineEdit.text
	global.settings.port = $ViewportContainer/VBoxContainer_settings/port_section/SpinBox.value
	global.settings.player_limit = $ViewportContainer/VBoxContainer_settings/player_limit_section/SpinBox.value
	global.settings.colour = $ViewportContainer/VBoxContainer_settings/colour_section/ColorPickerButton.color

func _on_LineEdit_ip_text_entered(new_text):
	if new_text.is_valid_ip_address():
		feedback.new_message("IP adress is valid", "good")
	else:
		feedback.new_message("IP adress is invalid", "bad")

