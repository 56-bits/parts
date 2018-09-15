extends Terrain

export var is_active : bool = true
export var speed : float = .1
var direction : float = 0

func _ready():
	direction = randf() * 2 * PI

func _process(delta):
	if is_active and is_network_master():
		while(direction > PI): direction -= 2*PI
		while(direction < -PI): direction += 2*PI
		
		direction += (randf()-.5)/100
	
	var velocity = Vector2(speed,0).rotated(direction) * delta
	
	position += velocity

func _network_tick():
	rpc("update_movement", position, direction)

slave func update_movement(pos, dir):
	position = pos
	dir = direction

func get_state() -> Dictionary:
	var state = {}
	
	var par_state : Dictionary = .get_state()
	
	for key in par_state.keys():
		state[key] = par_state[key]
	
	state["pos"] = position
	state["dir"] = direction
	state["spd"] = speed
	state["name"] = name
	
	return state

func set_state(state : Dictionary):
	.set_state(state)
	
	position = state["pos"]
	direction = state["dir"]
	speed = state["spd"]