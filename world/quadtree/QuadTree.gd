extends Node2D

class_name QuadTree

var bounding_box : Rect2
var is_leaf : bool = true

var data = 0

var min_size = 8

#children
var tr : QuadTree #top right
var tl : QuadTree #top left
var br : QuadTree #bottom right
var bl : QuadTree #bottom left

func _init(pos : Vector2, size : float, def_data = 0):
	var s = Vector2(size, size)
	bounding_box = Rect2(pos - s, s * 2)
	data = def_data
	refresh()

func insert_point(pos : Vector2, dat) -> bool:
	if !bounding_box.has_point(pos):
		return false
	
	var val = false
	
	if bounding_box.size.x > min_size:
		if is_leaf:
			subdivide()
		
		if tr.insert_point(pos, dat): val = true
		elif tl.insert_point(pos, dat): val = true
		elif br.insert_point(pos, dat): val = true
		elif bl.insert_point(pos, dat): val = true
		collapse()
	else:
		data = dat
	
	refresh()
	return val

func insert_region(area : Rect2, dat):
	collapse()
	if !area.intersects(bounding_box):
		return
	
	if area.encloses(bounding_box) and data != dat:
		if !is_leaf:
			tr.delete()
			tl.delete()
			br.delete()
			bl.delete()
		
		is_leaf = true
		data = dat
		refresh()
		return
	
	if bounding_box.size.x > min_size and is_leaf:
		subdivide(data)
	
	if !is_leaf:
		tr.insert_region(area, dat)
		tl.insert_region(area, dat)
		br.insert_region(area, dat)
		bl.insert_region(area, dat)
	
	collapse()

func collapse():
	if !is_leaf:
		if tr.data == tl.data \
				&& tr.data == bl.data \
				&& tr.data == br.data \
				&& tr.is_leaf && tl.is_leaf && br.is_leaf && bl.is_leaf:
			is_leaf = true
			data = tr.data
			tr.delete()
			tl.delete()
			br.delete()
			bl.delete()
	refresh()
	

func subdivide(dat = data):
	is_leaf = false

	var size := bounding_box.size / 4
	var pos := (bounding_box.position + bounding_box.end)/2

	tr = get_script().new(pos - size.rotated(PI/2), size.x, dat)
	add_child(tr)
	tl = get_script().new(pos - size, size.x, dat)
	add_child(tl)
	br = get_script().new(pos + size, size.x, dat)
	add_child(br)
	bl = get_script().new(pos + size.rotated(PI/2), size.x, dat)
	add_child(bl)
	refresh()

func delete():
	if !is_leaf:
		tr.delete()
		tl.delete()
		br.delete()
		bl.delete()
	queue_free()

func refresh():
	if is_leaf and !has_node("rep") && data == 1:
		var rep = StaticBody2D.new()
		rep.name = "rep"
		
		var rect = RectangleShape2D.new()
		rect.extents = bounding_box.size/2
		
		var col = CollisionShape2D.new()
		col.shape = rect
		col.position = (bounding_box.position + bounding_box.end) / 2
		rep.add_child(col)
		
		add_child(rep)
	else:
		if has_node("rep"):
			get_node("rep").free()
	update()

func _draw():
#	var label = Label.new()
#	var font = label.get_font("")
#	label.free()
#	var c = get_child_count()
#	if c > 0:
#		draw_string(font,(bounding_box.position + bounding_box.end)/2, str(get_child_count())) 
	if is_leaf:
		match data:
			1:
				draw_rect(bounding_box, Color(.3, .6, .4), true)
				#draw_rect(bounding_box, Color(1,1,1), false)
			0:
				pass#draw_rect(bounding_box, Color(1,1,1), false)#
#	else:
#		tr.update()
#		tl.update()
#		br.update()
#		bl.update()
