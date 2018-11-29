extends Node

var menu_id : int = 0 setget menu_change

func _ready():
	randomize()
	
	$ViewportContainer/VBoxContainer_settings/name_section/LineEdit.text = globals.settings.player_name 
	$ViewportContainer/VBoxContainer_settings/ip_section/LineEdit.text = globals.settings.server_ip
	$ViewportContainer/VBoxContainer_settings/port_section/SpinBox.value = globals.settings.port
	$ViewportContainer/VBoxContainer_settings/player_limit_section/SpinBox.value = globals.settings.player_limit
	$ViewportContainer/VBoxContainer_settings/colour_section/ColorPickerButton.color = globals.settings.colour

func menu_change(new_id):
	menu_id = new_id
	
	match menu_id:
		0 :
			for c in $ViewportContainer.get_children():
				c.hide()
			$ViewportContainer/VBoxContainer_main.show()
		1 :
			for c in $ViewportContainer.get_children():
				c.hide()
			$ViewportContainer/VBoxContainer_settings.show()
		2 :
			for c in $ViewportContainer.get_children():
				c.hide()
			$ViewportContainer/VBoxContainer_experiments.show()
		_ :
			menu_id = 0

#button actions

## main menuu
func _on_ToolButton_server_pressed():
	#warning-ignore:return_value_discarded
	get_tree().change_scene("res://server/server.tscn")

func _on_ToolButton_client_pressed():
	#warning-ignore:return_value_discarded
	get_tree().change_scene("res://client/client.tscn")

func _on_ToolButton_experiments_pressed():
	self.menu_id = 2

func _on_ToolButton_settings_pressed():
	self.menu_id = 1

func _on_ToolButton_exit_pressed():
	get_tree().quit()

## settings
func _on_ToolButton_backSettings_pressed():
	self.menu_id = 0
	
	globals.settings.player_name = $ViewportContainer/VBoxContainer_settings/name_section/LineEdit.text
	globals.settings.server_ip = $ViewportContainer/VBoxContainer_settings/ip_section/LineEdit.text
	globals.settings.port = $ViewportContainer/VBoxContainer_settings/port_section/SpinBox.value
	globals.settings.player_limit = $ViewportContainer/VBoxContainer_settings/player_limit_section/SpinBox.value
	globals.settings.colour = $ViewportContainer/VBoxContainer_settings/colour_section/ColorPickerButton.color

func _on_LineEdit_ip_text_entered(new_text):
	if new_text.is_valid_ip_address():
		f.new_message("IP adress is valid", "good")
	else:
		f.new_message("IP adress is invalid", "bad")

## experiments

func _on_ToolButton_cinematic_pressed():
	#warning-ignore:return_value_discarded
	get_tree().change_scene("res://experiments/cinematic/TestCinematic.tscn")

func _on_ToolButton_QuadTree_pressed():
	#warning-ignore:return_value_discarded
	get_tree().change_scene("res://experiments/quadtree/qt.tscn")
	f.new_message("Press esc. to exit")

func _on_ToolButton_backExperiments_pressed():
	self.menu_id = 0