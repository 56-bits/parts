extends "res://menue/gui.gd"

func _on_resync_button_pressed():
	$"../".request_sync()
	$menu.visible = false
