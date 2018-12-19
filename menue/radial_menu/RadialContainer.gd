extends Control

class_name RadialContainer

export var radius = 32
export var arc_start = 0
export var arc_end = 2*PI
var arc_end_anim = arc_end

var t = Tween.new()

func _ready():
	add_child(t)

func anim_refresh():
	arc_end_anim = arc_start
	t.interpolate_method(self, "anim_arc", arc_start, arc_end, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0)
	t.start()

func anim_arc(a):
	arc_end_anim = a
	refresh()

func refresh():
	var children = get_children()
	children.erase(t)
	var elements = children.size()
	
	if !elements : return
	
	if arc_start > arc_end:
		var t = arc_start
		arc_start = arc_end
		arc_end = t
	
	var arc_length = arc_end_anim - arc_start
	var angle_spacing = arc_length / elements
	
	for i in range(elements):
		var angle = angle_spacing * i + arc_start
		var pos = Vector2(0, -radius)
		pos = pos.rotated(angle)
		
		var c : Control = children[i]
		c.rect_position = pos
		
		if c.has_method("set_rot"):
			c.rot = angle
		
#		if c is Label:
#			var a #horizontal alignment
#
#			if angle in [0, PI]:
#				a = GROW_DIRECTION_BOTH
#			elif angle > 0 and angle < PI:
#				a = GROW_DIRECTION_END
#			elif angle < 2*PI and angle > PI:
#				a = GROW_DIRECTION_BEGIN
#
#			c.grow_horizontal = a
#		else:
#			pass
#			c.grow_horizontal = GROW_DIRECTION_BOTH
#
#		c.grow_vertical = GROW_DIRECTION_BOTH