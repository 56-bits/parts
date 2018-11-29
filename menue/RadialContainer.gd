tool
extends Control

class_name RadialContainer

export var ref : bool = false setget refresh

export var radius = 32
export var arc_start = 0
export var arc_end = 2*PI

func refresh(val = false):
	
	var children = get_children()
	var elements = children.size()
	
	if !elements : return
	
	if arc_start > arc_end:
		var t = arc_start
		arc_start = arc_end
		arc_end = t
	
	var arc_length = arc_end - arc_start
	var angle_spacing = arc_length / elements
	
	for i in range(elements):
		var angle = angle_spacing * i + arc_start
		var pos = Vector2(0, -radius)
		pos = pos.rotated(angle)
		
		var c : Control = children[i]
		c.rect_position = pos
		
		if c is Label:
			var a #horizontal alignment
			
			if angle in [0, PI]:
				a = GROW_DIRECTION_BOTH
			elif angle > 0 and angle < PI:
				a = GROW_DIRECTION_END
			elif angle < 2*PI and angle > PI:
				a = GROW_DIRECTION_BEGIN
			
			c.grow_horizontal = a
		else:
			c.grow_horizontal = GROW_DIRECTION_BOTH
		
		c.grow_vertical = GROW_DIRECTION_BOTH
		
	ref = false