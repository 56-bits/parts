extends CanvasLayer

var queue = []
var message_limit = 20

func _ready():
	pass#push_align(VALIGN_BOTTOM)

func refresh():
	if queue.size() > message_limit:
		queue.pop_front()
	
	#clear present text
	$rtl.text = ""
	for message in queue:
		
		$rtl.newline()
		
		#choose message colour
		match message.status:
			"good":
				$rtl.push_color(Color(0.1,0.9,0.1))
			"bad":
				$rtl.push_color(Color(0.9,0.1,0.1))
			_:
				$rtl.push_color(Color(0.8,0.8,0.8))
		
		$rtl.add_text(message.txt)

func new_message(message : String, type = ""):
	print(message)
	queue.push_back({txt = message, status = type})
	refresh()
