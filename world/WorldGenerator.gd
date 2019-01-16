extends Node
class_name WorldGenerator

var tgen = TerrainGenerator.new()
var t : Terrain

func _ready():
	f.m("generator initialized")
	add_child(tgen)
	tgen.t = t

func generate():
	tgen.generate_terrain()

class TerrainGenerator:
	extends Node
	
	var n = OpenSimplexNoise.new()
	var t : Terrain
	
	func _init():
		n.octaves = 6
		n.period = 100
		n.lacunarity = 1.5
		n.persistence = 0.8
		n.seed = randi()
		f.m("terrain generator initialized")
		
	func generate_terrain():
		t.call_deferred("rpc", "direct_list_edit", get_list())
		
	func get_list():
		
		var l = {}
		
		for i in range(-200,200):
			
#			yield(get_tree(), "idle_frame")
			var h = int((n.get_noise_2d(i, 0)) * 60)
			
			if abs(i) < 46:
				h = 0
			
			for j in range(h + 60):
				var p = Vector2(i, 60-j)
				
				var type = abs(int(floor(n.get_noise_2dv(p)*6)))
				l[p] = type
		
		return l