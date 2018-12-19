extends KinematicBody2D

var speed : float = 150

var air_multiplier : float = 0.75

var sprint_multiplier : float = 1.5
var is_sprinting : bool = false

var jump_speed : float = 180

var gravity : float = 10

var velocity : Vector2 = Vector2() 
var dir : Vector2 = Vector2()

var last_floor_vel : Vector2 = Vector2()

var colour : Color = Color(randf(),randf(),randf()) setget change_colour

func _ready():
	change_colour(colour)
#warning-ignore:unused_variable
func _physics_process(delta):
	
	if is_on_floor():
		velocity.x += dir.x * speed * 0.5
		
		if dir.x == 0:
			velocity.x = 0
		
		velocity.y = 0
		
		if dir.y < 0:
			velocity.y = -jump_speed
		
		last_floor_vel = get_floor_velocity()
		
	else:
		if abs(velocity.x) < abs(dir.x * speed * air_multiplier):
			velocity.x = dir.x * speed * air_multiplier * 0.5
		
		if dir.x == 0:
			velocity.x -= velocity.x * air_multiplier
		
		if dir.y < 0 and velocity.y < 0:
			velocity.y -= gravity/4
		
		velocity.y += gravity
		
		velocity.x += last_floor_vel.x
	
	#increase speed for sprinting
	if is_sprinting:
		velocity.x = clamp(velocity.x, -speed * sprint_multiplier, speed * sprint_multiplier)
	else:
		velocity.x = clamp(velocity.x, -speed, speed)
	
	#velocity += get_floor_velocity()
	if dir.y < 0:
		#warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector2(0, -1))
	else:
		#warning-ignore:return_value_discarded
		move_and_slide_with_snap(velocity, Vector2(0, 10), Vector2(0, -1))

func change_colour(new_colour : Color) -> void:
	colour = new_colour
	$Sprite.modulate = new_colour

func move(direction : Vector2 = Vector2(0,0), sprint : bool = false) -> void:
	dir = direction.normalized()
	is_sprinting = sprint
