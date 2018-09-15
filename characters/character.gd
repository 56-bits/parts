extends KinematicBody2D

var speed : float = 150

var air_multiplier : float = 0.75

var sprint_multiplier : float = 2
var is_sprinting : bool = false

var jump_speed : float = 200

var gravity : float = 10

var velocity : Vector2 = Vector2() 
var dir : Vector2 = Vector2()

var last_floor_vel : Vector2 = Vector2()

var colour : Color = Color(randf(),randf(),randf()) setget change_colour

func _ready():
	$Particles2D.restart()
	change_colour(colour)

func _physics_process(delta):
		
	if is_on_floor():
		velocity.x = dir.x * speed
		velocity.y = 0
		
		if dir.y < 0:
			velocity.y = -jump_speed
		
		last_floor_vel = get_floor_velocity()
		
	else:
		velocity.x = dir.x * speed * air_multiplier
		
		if dir.y < 0 and velocity.y < 0:
			velocity.y -= 5
		
		velocity.y += gravity
		
		velocity.x += last_floor_vel.x
	
	#increase speed for sprinting
	if is_sprinting:
		velocity.x *= sprint_multiplier
		
	#velocity += get_floor_velocity()
	if dir.y < 0:
		move_and_slide(velocity, Vector2(0, -1))
	else:
		move_and_slide_with_snap(velocity, Vector2(0, 10), Vector2(0, -1))
	

func change_colour(new_colour : Color) -> void:
	colour = new_colour
	$Sprite.modulate = new_colour

func move(direction : Vector2 = Vector2(0,0), sprint : bool = false) -> void:
	dir = direction.normalized()
	is_sprinting = sprint