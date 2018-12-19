extends Control

var rect : Rect2 = Rect2(10, 10, 10, 10)
onready var rot : float = PI setget set_rot
onready var icon : Texture = preload("res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex") setget set_icon
var icon_half_size = Vector2(64,64)
var hover = false
var text setget set_text
var max_text_size = 128

var quadrant = 0 setget quadrant_changed

func _ready():
	$Icon.rect_position = Vector2(-32, -32)
	self.rot = 0

func resize():
	var rect_i = Rect2($Icon.rect_position, $Icon.rect_size)
	var rect_t = Rect2($Text.rect_position, $Text.rect_size)
	
	rect = rect_i.merge(rect_t)
	
	$Extents.rect_position = rect.position
	$Extents.rect_size = rect.size
	
	update()

func _draw():
#	return #comment out to enable debug
	draw_rect(rect, Color(1,0,0), false)
	draw_line(Vector2(), Vector2(0,-100).rotated(rot), Color(0,1,0))

func set_rot(r = rot):
	rot = r
	
	while rot < 0 or rot > 2 * PI:
		if rot < 0:
			rot += 2*PI
		if rot > 2*PI:
			rot -= 2*PI
	
	if rot < 0.1 or rot - 2 * PI > 0.1:
		self.quadrant = 0
	elif abs(rot - PI) <= 0.1:
		self.quadrant = 1
	elif rot > 0 and rot < PI:
		self.quadrant = 2
	elif rot > PI and rot < 2*PI:
		self.quadrant = 3
	
	
	resize()

func set_text(t = text):
	text = t
	$Text.text = text
	yield($Text, "resized")
	resize()

func set_icon(tex):
	icon = tex
	if icon != null:
		$Icon.texture = icon
	else:
		icon = preload("res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex")
		$Icon.texture = icon
	icon_half_size = icon.get_size()/2
	
	$Icon.rect_position = -icon_half_size
	
	set_rot()

func quadrant_changed(q):
	if quadrant != q:
		quadrant = q
		if has_node("Text"):
			var t = Label.new()
			t.name = "Text"
			
			$Text.queue_free()
			yield($Text, "tree_exited")
			
			add_child(t)
			
			var gh
			var gv
			var a
			var av
			
			match quadrant:
				0:
					gh = GROW_DIRECTION_BOTH
					gv = GROW_DIRECTION_BEGIN
					a = Label.ALIGN_CENTER
					av = Label.VALIGN_BOTTOM
					$Text.rect_position = Vector2(0, -icon_half_size.y)
				1:
					gh = GROW_DIRECTION_BOTH
					gv = GROW_DIRECTION_END
					a = Label.ALIGN_CENTER
					av = Label.VALIGN_TOP
					$Text.rect_position = Vector2(0, icon_half_size.y)
				2:
					gh = GROW_DIRECTION_END
					gv = GROW_DIRECTION_BOTH
					a = Label.ALIGN_LEFT
					av = Label.VALIGN_CENTER
					$Text.rect_position = Vector2(icon_half_size.x, 0)
				3:
					gh = GROW_DIRECTION_BEGIN 
					gv = GROW_DIRECTION_BOTH
					a = Label.ALIGN_RIGHT
					av = Label.VALIGN_CENTER
					$Text.rect_position = Vector2(-icon_half_size.x, 0)
				
			$Text.grow_horizontal = gh
			$Text.grow_vertical = gv
			$Text.valign = av
			$Text.align = a
			
			if text:
				$Text.text = str(text)
			
			if $Text.rect_size.x >= max_text_size:
				$Text.rect_size.x = max_text_size
				$Text.autowrap = true
			else:
				$Text.autowrap = false
			
			yield($Text, "resized")
			
			resize()


func _on_Extents_mouse_entered():
	f.m("en")
	hover = true

func _on_Extents_mouse_exited():
	f.m("ex")
	hover = false
