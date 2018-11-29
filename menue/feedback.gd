extends CanvasLayer

var queue = []
var message_limit = 20

enum {
	GOOD
	BAD
	NONE
}

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
			GOOD:
				$rtl.push_color(Color(0.1,0.9,0.1))
			BAD:
				$rtl.push_color(Color(0.9,0.1,0.1))
			_:
				$rtl.push_color(Color(0.8,0.8,0.8))
		
		$rtl.add_text(message.txt)

func new_message(message : String, type = NONE):
	print(message)
	queue.push_back({txt = message, status = type})
	refresh()

#short cut for new_message
func m(message : String, type = NONE):
	new_message(message, type)