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
#	var tgen_thread = Thread.new()
#	tgen_thread.start(tgen, "generate_terrain")
	

class TerrainGenerator:
	extends Node
	
	var n = OpenSimplexNoise.new()
	var t : Terrain
	
	func _init():
		n.octaves = 6
		n.period = 100
		n.lacunarity = 1.5
		n.persistence = 0.8
		n.seed = 1
		f.m("terrain generator initialized")
		
	func generate_terrain():
#		f.m("generating terrain")
		t.call_deferred("rpc", "direct_list_edit", get_list())
#		f.m("terrain generated")
		
	func get_list():
		
		var l = {}
		
		for i in range(-1000,1000):
			
#			yield(get_tree(), "idle_frame")
			var h = int((n.get_noise_2d(i, 0)) * 100)
			
			if abs(i) < 50:
				h = 0
			
			for j in range(h + 100):
				var p = Vector2(i, 100-j)
				
				var type = abs(int(n.get_noise_2dv(p)*6))
				l[p] = type
		
		return l