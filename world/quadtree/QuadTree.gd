extends Node2D

class_name QuadTree

var bounding_box : Rect2
var is_leaf : bool = true

var data = 0

#children
var tr : QuadTree #top right
var tl : QuadTree #top left
var br : QuadTree #bottom right
var bl : QuadTree #bottom left

func _init(pos : Vector2, size : float, def_data = 0):
	var s = Vector2(size, size)
	bounding_box = Rect2(pos - s, s * 2)
	data = def_data

func insert_data(pos : Vector2, dat) -> bool:
	if !bounding_box.has_point(pos):
		return false
	
	if is_leaf && bounding_box.size.x > 4:
		subdivide()
	
	var val = false
	
	if bounding_box.size.x > 4:
		if tr.insert_data(pos, dat): val = true
		elif tl.insert_data(pos, dat): val = true
		elif br.insert_data(pos, dat): val = true
		elif bl.insert_data(pos, dat): val = true
		collapse()
	else:
		data = dat
	
	return val

func collapse():
	if !is_leaf:
		if tr.data == tl.data \
		&& tr.data == bl.data \
		&& tr.data == br.data \
		&& tr.is_leaf && tl.is_leaf && br.is_leaf && bl.is_leaf :
			is_leaf = true
			data = tr.data
			tr.delete()
			tl.delete()
			br.delete()
			bl.delete()

func subdivide():
	is_leaf = false

	var size := bounding_box.size / 4
	var pos := (bounding_box.position + bounding_box.end)/2

	tr = get_script().new(pos - size.rotated(PI/2), size.x, data)
	add_child(tr)
	tl = get_script().new(pos - size, size.x, data)
	add_child(tl)
	br = get_script().new(pos + size, size.x, data)
	add_child(br)
	bl = get_script().new(pos + size.rotated(PI/2), size.x, data)
	add_child(bl)

func delete():
	if !is_leaf:
		tr.delete()
		tl.delete()
		br.delete()
		bl.delete()
	
	queue_free()


func _draw():
	if is_leaf:
		match data:
			1:
				draw_rect(bounding_box, Color(.5, .5, 1), true)
				draw_rect(bounding_box, Color(1,1,1), false)
			0:
				draw_rect(bounding_box, Color(1,1,1), false)
		
	else:
		tr.update()
		tl.update()
		br.update()
		bl.update()
