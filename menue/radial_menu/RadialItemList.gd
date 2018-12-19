extends Control

class_name RadialItemList

export var contents = {
	"test" : "somthing",
	"other item" : "other something",
	"1" : 1,
	"2long" : 2,
	"3isgood" : 2,
	"4" : 2,
	"5superduper ultra mecha kakoii longuuu" : 2
}

export var icon_size : int = 64

var b = RadialContainer.new()

func _ready():
	add_child(b)
	
	refresh()

func refresh():
	
	var elements = contents.size()
	b.radius = 1.5*icon_size / (2 * sin(PI / elements))
	
	for c in contents:
		
		var r = preload("res://menue/radial_menu/RadialButton.tscn").instance()
		b.add_child(r)
		r.text = c
	
	(b as RadialContainer).anim_refresh()