tool
extends Control

class_name RadialItemList

export var ref : bool = false setget refresh

export var contents = {
	"test" : "somthing",
	"other item" : "other something",
	"1" : 1,
	"2long" : 2,
	"3isgood" : 2,
	"4" : 2,
	"5superduper ultra mecha kakoii longuuu" : 2
}

export var icon_size : int = 32

var icons = RadialContainer.new()
var texts = RadialContainer.new()

func _ready():
	add_child(icons)
	add_child(texts)

func refresh(val = false):
	
	var elements = contents.size()
	icons.radius = 1.5*icon_size / (2 * sin(PI / elements))
	texts.radius = icons.radius + icon_size * 1.5
	
	for c in contents:
		var l = Label.new()
		l.rect_min_size = Vector2(0,0)
		l.rect_size = l.rect_min_size
		l.text = c
		texts.add_child(l)
		
		var p = Panel.new()
		p.modulate = Color(1,0,0)
		p.rect_min_size = Vector2(icon_size,icon_size)
		icons.add_child(p)
		
	icons.refresh()
	texts.refresh()
	ref = false