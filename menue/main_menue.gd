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
	
	for c in $ViewportContainer.get_children():
		c.hide()
	
	match menu_id:
		0 :
			$ViewportContainer/Main.show()
		1 :
			$ViewportContainer/VBoxContainer_settings.show()
		2 :
			$ViewportContainer/Experiments.show()
		_ :
			menu_id = 0

#button actions

## main menu
func _on_Main_item_selected(index):
	match index:
		0:
			get_tree().change_scene("res://server/server.tscn")
		1:
			get_tree().change_scene("res://client/client.tscn")
		2:
			self.menu_id = 2
		3:
			self.menu_id = 1
		4:
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
func _on_Experiments_item_selected(index):
	match index:
		0:
			get_tree().change_scene("res://experiments/cinematic/TestCinematic.tscn")
		1:
			get_tree().change_scene("res://experiments/quadtree/qt.tscn")
			f.new_message("Press esc. to exit")
		2:
			self.menu_id = 0