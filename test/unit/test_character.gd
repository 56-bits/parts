extends "res://addons/gut/test.gd"

var Character = load("res://characters/character.tscn")

func prerun_setup():
	gut.p('script:  pre-run')

func setup():
	gut.p('script:  setup')

func teardown():
	gut.p('script:  teardown, reset world')
	for child in get_children():
		child.queue_free()

func postrun_teardown():
	gut.p('script:  post-run')

func test_falling():
	gut.p("--falling test--")
	
	var _character = Character.instance()
	add_child(_character)
	
	yield(yield_for(1), YIELD)
	
	assert_almost_eq(_character.position.y, 315.0, 3.0, "The distance fallen should be the same")

func test_right_left_equality():
	pending("should move right and left and still arrive at start")

func test_terrain_movement():
	pending("a test for on-terrain movement")

func test_slope():
	pending("a test for moving on slopes")

func test_collision():
	pending("Should bump into a piece of terrain")