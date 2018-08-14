extends Node2D

var speed = 100
var movement = Vector2(0,0)
var sprint = false

var is_interpolating = false
var last_pos = Vector2(0,0)

func _ready():
	pass

func _process(delta):
	
	$character.move(movement, sprint)
	
#	if is_interpolating:
#		#code for interpolating
#		position += (last_pos - position)/4
#
#		#stop interpolating when teh distance can be covered "naturally"
#		if (position - last_pos).length() < speed * delta:
#			is_interpolating = false
#			position = last_pos
#	else:
#		position += movement * speed * delta


slave func update_movement(pos, mov, spr):
	position = pos
	movement = mov
	sprint = spr

#	last_pos = pos
#
#	var diff = (position - last_pos).length()
#
#	if diff < 2:
#		#if the differnce is small just snap to positon
#		position = last_pos
#	elif diff > 100:
#		# if the difference is wayy to big, teleport anyways
#		position = last_pos
#	else:
#		#if the differnce is bigger interpolate to it
#		is_interpolating = true
	
	