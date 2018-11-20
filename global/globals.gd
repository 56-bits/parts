extends Node

var settings = {
	player_name = "Guest",
	server_ip = "localhost",
	port = 8080,
	player_limit = 8,
	colour = Color(1, 1, 1)
}

onready var feedback = $"gui/feedback"

func _init():
	var gui_layer = CanvasLayer.new()
	gui_layer.name = "gui"
	add_child(gui_layer)
	gui_layer.add_child(preload("res://menue/feedback.tscn").instance())


#
#var config_file = ConfigFile.new()
#
#func _ready():
#	var err = config_file.load("user://settings.cfg")
#	if err == OK:
#		settings.player_name = config_file.get_value("main", "player_name", settings.player_name)
#		settings.server_ip = config_file.get_value("main", "server_ip", settings.server_ip)
#		settings.port = config_file.get_value("main", "port", settings.port)
#		settings.player_limit = config_file.get_value("main", "player_limit", settings.player_limit)
#
#		config_file.save("user://settings.cfg")
#	else:
#		config_file.save("user://settings.cfg")
#		printerr(err)
#
#func _init():
#	pass
#
#func _notification(what):
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#
#
#		var err = config_file.load("user://settings.cfg")
#
#		if err == OK:
#			config_file.set_value("main", "player_name", settings.player_name)
#			config_file.set_value("main", "server_ip", settings.server_ip)
#			config_file.set_value("main", "port", settings.port)
#			config_file.set_value("main", "player_limit", settings.player_limit)
#
#			config_file.save("user://settings.cfg")
#		else:
#			printerr(err)
#
#		get_tree().quit() # default behavior