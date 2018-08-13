extends KinematicBody2D

var speed = 150

var air_multiplier = 0.75

var sprint_multiplier = 2
var is_sprinting = false

var jump_speed = 200

var velocity = Vector2(0,0) 
var dir = Vector2(0,0)

func _ready():
	$Particles2D.restart()
	$Sprite.modulate = Color(randf(), randf(), randf())

func _physics_process(delta):
	
	if is_on_floor():
		velocity.x = dir.x * speed
		
		if dir.y < 0:
			velocity.y = -jump_speed
		
	else:
		velocity.x = dir.x * speed * air_multiplier
		
		velocity.y += 10
	
	#increase speed for sprinting
	if is_sprinting:
		velocity.x *= sprint_multiplier
	
	move_and_slide(velocity, Vector2(0, -1))
	
	#apply movement to controller
	get_parent().position += position
	position = Vector2(0,0)

sync func move(direction = Vector2(0,0), sprint = false):
	dir = direction.normalized()
	is_sprinting = sprint