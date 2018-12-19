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
		n.octaves = 8
		n.period = 100
		n.lacunarity = 1.5
		n.persistence = 0.8
		f.m("terrain generator initialized")
		
	func generate_terrain():
		f.m("generating terrain")
		t.edit_terrain(Vector2(0,0), 3)
		
		for i in range(50,5000):
			
			var h = int((n.get_noise_2d(i, 0)) * 50)
			
			for j in range(abs(h) + 50):
				
				var p = Vector2(i, j * sign(h)+50)
				var type = abs(int(n.get_noise_2dv(p)*5))
				t.rpc("direct_edit",p, type)
				
				yield(get_tree(), "idle_frame")
		
		f.m("terrain generated")